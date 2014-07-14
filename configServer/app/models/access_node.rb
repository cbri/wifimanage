class AccessNode < ActiveRecord::Base
  default_scope order('updated_at DESC')
  has_many :connections
  has_many :trusted_macs
  has_many :black_macs
  has_many :public_ips
  has_many :online_connections, :class_name => "Connection", :conditions => "used_on is not null and (expired_on is null or expired_on > NOW())"
  has_one :auth
  has_one :conf
  has_one :address
  belongs_to :nodecmd

  attr_accessible :last_seen, :mac, :name, :portal_url, :redirect_url, :remote_addr, :sys_memfree, :sys_upload, :sys_uptime, :update_time, :cmdflag, :configflag, :cmdline, :time_limit, :auth, :lat, :long, :developer, :nodecmd_id,:ssid
  validates :name, presence: true, uniqueness:true

  VALID_MAC_REGEX = /^[0-9A-F]+$/
  validates :mac, presence:true, uniqueness:true, length: { is:12 }, format: { with: VALID_MAC_REGEX }
  before_validation :sanitize_mac

  class << self
    def show_unlinked
      AccessNode.where("last_seen < ? and last_seen > ? ",Time.now - 60, Time.now - 600)
    end

    def disconnect
      nodes = AccessNode.show_unlinked
      nodes.each do |node|
        node.clean_all_conn
      end
    end
    
    def count_online_node
      AccessNode.where("last_seen > ? ", Time.now-60 ).count
    end


  end

  def show_online
    self.online_connections.count
  end

  def list_uniq_mac
    self.connections.select(:mac).uniq
  end

  def sanitize_mac
    self.mac = AccessNode.sanitize_mac_address(self.mac)
  end

  def self.find_by_mac(mac)
    self.find(:first, :conditions => ["mac = ?", sanitize_mac_address(mac)])
  end

  def self.sanitize_mac_address(mac)
    return nil if mac.nil?
    mac.gsub(/[:-]/, "").upcase
  end

  def total_up
    bytes_up = 0
    connections = self.connections.find(:all, :conditions => [ 'created_at > ?', Time.now - 1.month ])
    connections.each do |connection|
      unless connection.outgoing.nil?
        bytes_up += connection.outgoing
      end
    end
    return bytes_up
  end

  def total_down
    bytes_down = 0
    connections = self.connections.find(:all, :conditions => [ 'created_at > ?', Time.now - 1.month ])
    connections.each do |connection|
      unless connection.incoming.nil?  
        bytes_down += connection.incoming
      end
    end
    return bytes_down
  end

  def running?
    if self.last_seen && Time.now-self.last_seen < 60
      return true;
    else
      return false;
    end 
  end
 
  def clean_all_conn 
    connections = self.online_connections
    connections.each do |connection|
      connection.expire!
    end
  end

  def show_running?
    if self.last_seen && Time.now-self.last_seen < 60
      return true;
    else
      return false;
    end 
  end

  def banned_mac?(mac)
    self.black_macs.each do |black|
      if black.mac == mac
        return true;
      end
    end
    return  false;
  end

  def self.addnodes(params)
    #if params[:AP].nil? || params[:AP].length > 10
    #  {:check=>false,:code=>104, :msg=>"AP More Than ten"}
    #else
      begin
        self.transaction do
          #params[:AP].each do |param|
            object = params[:data]
            object[:developer] = params[:username]
            logger.info "zc begin creating"
            access = self.create!(object)
            logger.info "zc  node.id=#{access.id}"
            Auth.create!(auth_type:"radius",auth_device:false,access_node_id:access.id)
            logger.info "zc auth created!"
            Conf.create!(access_node_id:access.id)
            logger.info "zc conf created!"
            ob_address = params[:address]
            Address.create!(access_node_id:access.id,city:ob_address[:city],detail:ob_address[:detail],province:ob_address[:province],district:ob_address[:district])
            ob_contact = params[:contact]
            logger.info "zc address created"
            Contact.create!(access_node_id:access.id,merchant:ob_contact[:merchant],name:ob_contact[:name],phonenum:ob_contact[:phonenum],telephonenum:ob_contact[:telephonenum],email:ob_contact[:email],weixin:ob_contact[:weixin],node_mac:object[:mac])
            logger.info "zc contact created"
          #end
        end
      rescue Exception => e
        return {:check=>false,:code=>105, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true, :code=>200, :msg=>"Success", :serverIP=>""}
    #end
  end

  def self.bindurl(params)
    if params[:data].nil? || params[:data].length > 10
      {:check=>false,:code=>104, :msg=>"Data More Than ten"}
    else
      begin
        self.transaction do
          params[:data].each do |object|
            object[:developer] = params[:username]
            access = self.create!(object)
            Auth.create!(auth_type:"radius",auth_device:false,access_node_id:access.id)
            Conf.create!(access_node_id:access.id)
          end
        end
      rescue Exception => e
        return {:check=>false,:code=>105, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true, :code=>200, :msg=>"Success"}
    end
  end

  def self.update_publicip(params)
    if params[:data].nil? || params[:data].length > 5
      {:check=>false,:code=>104, :msg=>"Data More Than Five"}
    elsif  !access=self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        self.transaction do
          access.public_ips.delete_all
          params[:data].each do |object|
            object[:access_node_id]=access.id
            PublicIp.create!(object);
          end
     	  access.update_attributes( :configflag => true );
     	  access.clean_all_conn 
        end
      rescue Exception => e
        return {:check=>false,:code=>105, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true, :code=>200, :msg=>"Success"}
    end
  end
  
  def self.update_trustedmacs(params)
    if params[:data].nil? || params[:data].length > 5
      {:check=>false,:code=>104, :msg=>"Data More Than Five"}
    elsif  !access=self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        self.transaction do
          access.trusted_macs.delete_all
          params[:data].each do |object|
            object[:access_node_id]=access.id
            TrustedMac.create!(object);
          end
          access.update_attributes( :configflag => true );
          access.clean_all_conn
        end
      rescue Exception => e
        return {:check=>false,:code=>105, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true, :code=>200, :msg=>"Success"}
    end
  end

  def self.show_connections(mac)
    access = self.find_by_mac(mac)
    if  access
      connections = Connection.show_by_date(access,Time.now.to_date)
      status = Status.first
      { :check=>true,  :conn=>connections, :status => status }
    else
      {:check=>false, :code=>102,:msg=>"Not Found AccessNode"}
    end
  end

  def self.update_auth_type(params)
    times = params[:times].to_i
    if times<=0 or times>5
      {:check=>false, :code=>102, :msg=>"Execced Max Number"}
    elsif params[:authtype].nil? or !access=self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
        authtype = params[:authtype].to_s  
      begin
        access.auth.update_attributes!(auth_type:authtype) 
      rescue Exception => e
        {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end


  def self.update_auth_device(params)
    times = params[:times].to_i
    if times<=0 or times>5
      return {:check=>false, :code=>102, :msg=>"Execced Max Number"}
    elsif !access=self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        access.auth.update_attributes!(auth_device:params[:authdevice]) 
      rescue Exception => e
        return {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end

  def self.update_access_time(params)
    times = params[:times].to_i
    timeline = params[:time_delay].to_i
    if times<=0 or times>5
      return {:check=>false, :code=>102, :msg=>"Execced Max Number"}
    elsif  timeline > 720 or timeline <= 0
      return {:check=>false, :code=>105, :msg=>"Set Wrong Time"}
    elsif !access = self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        access.update_attributes!(time_limit:timeline) 
      rescue Exception => e
        return {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end

  def self.update_cmdline(params)
    times = params[:times].to_i
    nodecmd_id = params[:nodecmd_id].to_i
    if times<=0 or times>5
      return {:check=>false, :code=>102, :msg=>"Execced Max Number"}
    elsif  nodecmd_id > 6 or nodecmd_id <= 0
      return {:check=>false, :code=>105, :msg=>"Set Wrong Number"}
    elsif !access = self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        access.update_attributes!(:nodecmd_id=>params[:nodecmd_id],:cmdflag =>true )
      rescue Exception => e
        return {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end

  def self.update_conf(params)
    times = params[:times].to_i
    if times<=0 or times>5
      return {:check=>false, :code=>102, :msg=>"Execced Max Number"}
    elsif  params[:checkinterval].nil? or params[:authinterval].nil? or params[:clienttimeout].nil? or params[:httpmaxconn].nil?
      return {:check=>false, :code=>105, :msg=>"Less Params Error"}
    elsif !access = self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        access.conf.update_attributes(checkinterval:params[:checkinterval],authinterval:params[:authinterval],clienttimeout:params[:clienttimeout],httpmaxconn:params[:httpmaxconn])
     	access.update_attributes( :configflag => true );
     	access.clean_all_conn 
      rescue Exception => e
        return {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end

  def self.create_address(params)
    if  params[:city].nil? or params[:province].nil? or params[:district].nil? or params[:detail].nil?
      return {:check=>false, :code=>105, :msg=>"Less Params Error"}
    elsif !access = self.find_by_mac(params[:mac])
      {:check=>false, :code=>104,:msg=>"Not Found AccessNode"}
    else
      begin
        Address.create!(city:params[:city],province:params[:province],district:params[:district],detail:params[:detail],access_node_id:access.id)
      rescue Exception => e
        return {:check=>false,:code=>103, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true,:code=>200,:msg=>"Success"}
    end
  end


   def self.ping(params)
     node = self.find_by_mac(params[:gw_id])
     pongstr = "Pong"
     if node
       node.update_attributes(
         :sys_uptime => params[:sys_uptime],
         :sys_upload => params[:sys_load],
         :sys_memfree => params[:sys_memfree],
         :update_time => params[:wifidog_uptime],
         #:remote_addr => request.remote_addr,
         :ssid => params[:ssid],
         :last_seen => Time.now
       )

       if node.cmdflag == true
         node.update_attributes( :cmdflag => false );
         pongstr += ":cmdflag"
       elsif node.configflag == true
         node.update_attributes( :configflag => false );
         pongstr += ":configflag"
       end
     end
     pongstr
  end

  def self.retrieve(params)
    node = self.find_by_mac(params[:gw_id])
    str = "Cmd:"
    if !node.nodecmd.nil?
      str="Cmd:"+node.nodecmd.cmdline
    end
    str
  end

  def self.fetchconf(params)
    node = self.find_by_mac(params[:gw_id])
    str ="Conf:"
    if node
      node.update_attributes( :last_seen => Time.now, :configflag=>false, :cmdflag=>false )
      conf = node.conf
      if !conf.nil?
        str += "checkinterval="+conf.checkinterval.to_s+"&authinterval="+conf.authinterval.to_s+"&clienttimeout="+conf.clienttimeout.to_s+"&httpdmaxconn="+conf.httpmaxconn.to_s
      else
        str += "checkinterval=60&authinterval=60&clienttimeout=5&httpdmaxconn=10"
      end

      if !node.trusted_macs.empty?
        str += "&trustedmaclist="
        macs = Array.new
        node.trusted_macs.each do |trusted|
          macs.push(trusted.mac)
        end
        str += macs.join("+")
      end

      if !node.public_ips.empty?
        str += "&firewallrule="
        ips = Array.new
        node.public_ips.each do |ip|
          ips.push(ip.publicip)
        end
        str += ips.join("+")
      end
    end
    str
  end

  def self.login(params)
    node = self.find_by_mac(params[:gw_id]) 
    unless node
      redirect_url = "http://218.94.58.242"
    else
      if !node.redirect_url.blank?
        redirect_url = node.redirect_url+"&gw_address=#{params[:gw_address]}&gw_port=#{params[:gw_port]}&gw_id=#{params[:gw_id]}&public_ip=124.127.116.181&mac=#{params[:mac]}"
      end
      redirect_url ||= "/404"
    end
  end

  def self.portal(params)
    node = self.find_by_mac(params[:gw_id])
    unless node
      redirect_url = "/404"
    else
      if !node.portal_url.blank?
        redirect_url =  node.portal_url+"&mac="+params[:mac].to_s
      end
      redirect_url ||=  "http://www.baidu.com"
    end
  end

  def self.authenticate(params,device)
    node = self.find_by_mac(params[:gw_id])
    if node.nil? or  params[:gw_id].nil? or params[:gw_address].nil? or params[:gw_port].nil? or !node.auth.check_device(device)
      redirect_url = "/404"
    else
      #unless node.auth.authenticate params[:username],params[:checkcode],"local"
      unless true
        redirect_url = node.redirect_url+"&gw_address=#{params[:gw_address]}&gw_port=#{params[:gw_port]}&gw_id=#{params[:gw_id]}&public_ip=124.127.116.177&mac=#{params[:mac]}"
      else
        token=SecureRandom.urlsafe_base64(nil, false)
        curcon=Connection.find(:first, :conditions => ["mac = ? and expired_on > NOW()",params[:mac]])
        logger.info(token)
        if curcon
           token=curcon.token
           logger.info(token)
        else
          if !node.time_limit.nil? and node.time_limit > 0
            login_connection = Connection.create!(:token => token,
                                                :phonenum => params[:username],
                                                :access_mac => params[:gw_id],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+node.time_limit.minutes,
                                                :portal_url => params[:url]
                                               )
          else
            login_connection = Connection.create!(:token => token,
                                                :phonenum => params[:username],
                                                :access_mac => params[:gw_id],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+30.minutes,
                                                :portal_url => params[:url]
                                               )
          end
        end
        redirect_url ||= "http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
      end
    end
  end

  def self.freeland(params)
    node = self.find_by_mac(params[:gw_id])
    if node.nil? or  params[:gw_id].nil? or params[:gw_address].nil? or params[:gw_port].nil? or params[:mac].nil? 
      return {:check=>false, :code=>102, :msg=>"Params Not Enough"}
    else
      token=SecureRandom.urlsafe_base64(nil, false)
      if !node.time_limit.nil? and node.time_limit > 0
        login_connection = Connection.create!(:token => token,
                                              :access_mac => params[:gw_id],
                                              :mac => params[:mac],
                                              :access_node_id => node.id,
                                              :expired_on => Time.now+node.time_limit.minutes,
                                              :portal_url => params[:url]
                                             )
      else
        login_connection = Connection.create!(:token => token,
                                              :access_mac => params[:gw_id],
                                              :mac => params[:mac],
                                              :access_node_id => node.id,
                                              :expired_on => Time.now+30.minutes,
                                              :portal_url => params[:url]
                                             )
      end
      redirect_url = "http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
    end
    {:check=>true, :code=>200, :msg=>redirect_url }
  end
end

