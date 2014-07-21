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
  has_one :contact
  belongs_to :nodecmd

  attr_accessible :last_seen, :mac, :name, :portal_url, :redirect_url, :remote_addr, :sys_memfree, :sys_upload, :sys_uptime, :update_time, :cmdflag, :configflag, :cmdline, :time_limit, :auth, :lat, :long, :developer,  :status,:nodecmd_id,:ssid,:incoming,:outgoing,:online_duration
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

  def self.expiredbyclient(mac)
      pool = Connection.find(:first, :conditions => [' mac =  ? ', mac],:order => "expired_on DESC",:limit => 1)
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
    if params[:AP].nil? and params[:data].nil? and params[:name]
      {:check=>false,:code=>104, :msg=>"param error"}
    elsif params[:data] 
      object = param[:data]
      object[:developer] = params[:username]
      access = self.create!(object)
      Auth.create!(auth_type:"radius",auth_device:false,access_node_id:access.id)
      Conf.create!(access_node_id:access.id)
      ob_address = param[:address]
      Address.create!(access_node_id:access.id,city:ob_address[:city],detail:ob_address[:detail],province:ob_address[:province],district:ob_address[:districtl])
      ob_contact = param[:contact]
      Contact.create!(access_node_id:access.id,merchant:ob_contact[:merchant],name:ob_contact[:name],phonenum:ob_contact[:phonenum],telephonenum:ob_contact[:telephonenum],email:ob_contact[:email],weixin:ob_contact[:weixin])
    elsif params[:name]
      access = self.create!(name:params[:contact],mac:params[:mac],redirect_url:params[:redirect_url],portal_url:params[:portal_url])
      Auth.create!(auth_type:"radius",auth_device:false,access_node_id:access.id)
      Conf.create!(access_node_id:access.id)
      Address.create!(access_node_id:access.id,city:params[:city],detail:params[:detail],province:params[:province],district:params[:districtl])
      Contact.create!(access_node_id:access.id,merchant:params[:merchant],name:params[:name],phonenum:params[:phonenum],telephonenum:params[:telephonenum],email:params[:email],weixin:params[:weixin])
      {:check=>true, :code=>200, :msg=>"Success", :serverIP=>""}
    else
      begin
        self.transaction do
          params[:AP].each do |param|
            object = param[:data]
            object[:developer] = params[:username]
            access = self.create!(object)
            Auth.create!(auth_type:"radius",auth_device:false,access_node_id:access.id)
            Conf.create!(access_node_id:access.id)
            ob_address = param[:address]
            Address.create!(access_node_id:access.id,city:ob_address[:city],detail:ob_address[:detail],province:ob_address[:province],district:ob_address[:districtl])
            ob_contact = param[:contact]
            Contact.create!(access_node_id:access.id,merchant:ob_contact[:merchant],name:ob_contact[:name],phonenum:ob_contact[:phonenum],telephonenum:ob_contact[:telephonenum],email:ob_contact[:email],weixin:ob_contact[:weixin])
            
          end
        end
      rescue Exception => e
        return {:check=>false,:code=>105, :msg=>"Insert Error #{e.to_s}"}
      end
      {:check=>true, :code=>200, :msg=>"Success", :serverIP=>""}
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
  
  def self.show_connections(mac)
    access = self.find_by_mac(mac)
    if  access
      connections = Connection.show_by_date(access,Time.now.to_date)
      status = Status.first
      tdown=access.total_down()
      tup=access.total_up()
      hour=access.update_time/3600
      second=(access.update_time - hour*3600)/60
      duration=hour.to_s+"hour"
      duration+=second.to_s+"second"
      access.update_attributes( :incoming => tdown,:outgoing => tup,:online_duration=>duration )
      { :check=>true , :conn=>connections, :status => status,:node => access }
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
       if node.status != "ping"
        observernodes = Observer.where("type = 1 ") 
        observernodes.each do |observernode|
           url = URI.parse(obeservernode.url)
           Net::HTTP.start(url.host, url.port) do |http|
             req = Net::HTTP::Post.new(url.path)
             req.set_form_data({ 'gw_id' => node.gw_id,'status' => 'online' })
             puts http.request(req).body
           end
        end
       end
       node.update_attributes(
         :sys_uptime => params[:sys_uptime],
         :sys_upload => params[:sys_load],
         :sys_memfree => params[:sys_memfree],
         :update_time => params[:wifidog_uptime],
         #:remote_addr => request.remote_addr,
         :ssid =>  params[:ssid],
         :last_seen => Time.now,
         :status => "ping"
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
        redirect_url = node.redirect_url+"&gw_address=#{params[:gw_address]}&gw_port=#{params[:gw_port]}&gw_id=#{params[:gw_id]}&public_ip=124.127.116.177&mac=#{params[:mac]}"
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
    if node.nil? or  params[:gw_id].nil? or params[:gw_address].nil? or params[:gw_port].nil? or params[:logintype].nil? or !node.auth.check_device(device)
      redirect_url = "/404"
    else
      unless node.auth.authenticate params[:username],params[:checkcode], params[:logintype]

        redirect_url = node.redirect_url+"&gw_address=#{params[:gw_address]}&gw_port=#{params[:gw_port]}&gw_id=#{params[:gw_id]}&public_ip=124.127.116.177&mac=#{params[:mac]}"
      else
        token=SecureRandom.urlsafe_base64(nil, false)
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

        redirect_url ||= "http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
      end
    end
  end

  def self.authenticate_new(params,device)
    node = self.find_by_mac(params[:gw_id])
    if node.nil?
        return {:check=>false,:code=>40104, :msg=>"gw_id parameter error "}
    end 
    if params[:gw_address].nil?
        return {:check=>false,:code=>40104, :msg=>"gw_address parameter error "}
    end
    if params[:gw_port].nil?
        return {:check=>false,:code=>40104, :msg=>"gw_port parameter error "}
    end
    if params[:client_MAC].nil?
        return {:check=>false,:code=>40104, :msg=>"client_MAC parameter error "}
    end
    if params[:gw_id].nil?
        return {:check=>false,:code=>40104, :msg=>"gw_id parameter error "}
    end
    if params[:url].nil?
        return {:check=>false,:code=>40104, :msg=>"url parameter error "}
    end
    if params[:username].nil?
        return {:check=>false,:code=>40104, :msg=>"username parameter error "}
    end
    ct = Time.now
    puts "ok"
    con = expiredbyclient(params[:client_MAC])
    limit_minutes=30.minutes
    if !node.time_limit.nil? and node.time_limit > 0
       limit_minutes=node.time_limit.minutes
    end
    btimeout=true
    bnewconnect = false;
    if con.nil?
       btimeout=false
    else
      if con.expired_on > ct 
         btimeout = false
      end 
      if con.expired_on < ct and con.expired_on <  (ct-limit_minutes)
          btimeout = false
          bnewconnect=true
      end
    end 
    btimeout = false
    if btimeout
       return {:check=>false,:code=>40205, :msg=>"expired "}
    else    
            token=SecureRandom.urlsafe_base64(nil, false)
            if bnewconnect or con.nil?
               
               if !node.time_limit.nil? and node.time_limit > 0
                   login_connection = Connection.create!(:token => token,
                                                :phonenum => params[:username],
                                                :access_mac => params[:gw_id],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+60.minutes,
                                                :portal_url => params[:url]
                                               )
               else
                   login_connection = Connection.create!(:token => token,
                                                :phonenum => params[:username],
                                                :access_mac => params[:gw_id],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+60.minutes,
                                                :portal_url => params[:url]
                                               )
            end
            else
               token=con.token
            end
            puts "http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
            {:check=>true,:code=>200, :token=>"#{token}", :msg=>"OK"}
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

