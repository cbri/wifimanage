require 'net/http'
class Connection < ActiveRecord::Base
  default_scope order('updated_at DESC')
  attr_accessible :access_mac, :access_node_id, :expired_on, :incoming, :ipaddr, :mac, :outgoing, :token, :used_on, :device, :portal_url, :phonenum, :status
  belongs_to :access_node

  validates_presence_of :access_mac

  class << self

    def count_online_conn 
      Connection.where("used_on is not null and (expired_on is null or expired_on > NOW() )").count
    end


    def list_by_date(page, date, node)
      if node.nil?
        paginate :per_page => 10, :page => page, :conditions => ['used_on > ?', date], :order => 'used_on desc'
      else
        paginate :per_page => 10, :page => page, :conditions => ['used_on > ? AND access_mac = ?', date, node.mac], :order => 'used_on desc'
      end
    end 

    def list_by_mac(page,mac,date)
      paginate :per_page => 10, :page => page, :conditions => ['used_on > ? AND mac = ?', date, mac]
    end

    def unique_by_date(date)
      unique_macs = []
      pool = Connection.find(:all, :conditions => ['used_on > ?', date])
      pool.each do |conn|
        unless unique_macs.include? conn.mac
          unique_macs.push(conn.mac)             
        end
      end
      unique_macs
    end

    def show_by_date(node,date)
      if node.nil?
        paginate :per_page => 20, :page => 1, :conditions => ['used_on > ?', date], :order => 'used_on desc'
      else
        paginate :per_page => 20, :page => 1, :conditions => ['used_on > ? AND access_mac = ?', date, node.mac], :order => 'used_on desc'
      end
    end 
    

  end

  def expired?
    return false if self.expired_on.nil?
    self.expired_on < Time.now
  end

  def used?
    return true if self.used_on
  end

  def expire!
    self.update_attribute("expired_on", Time.now)
    self.save
  end

  def use!
    self.update_attribute("used_on", Time.now)
  end

  def self.authupdate(params) 
    auth = 0
    if !connection = self.find_by_token(params[:token])
      logger.info "Invalid token: #{params[:token]}"
    else 
      case params[:stage]
      when 'login'
        if connection.expired? or connection.used?
          logger.info "Tried to login with used or expired token: #{params[:token]}"
        else
          connection.update_attributes({
            :mac => params[:mac],
            :ipaddr => params[:ip],
            :incoming => params[:incoming],
            :outgoing => params[:outgoing],
            :used_on => Time.now,
            :status => "login"
          })                        
          auth = 1
        
          observerconns = Observer.where("type = 2 ") 
          observerconns.each do |observerconn|
             url = URI.parse(observerconn.url)
             Net::HTTP.start(url.host, url.port) do |http|
                req = Net::HTTP::Post.new(url.path)
                req.set_form_data({ 'gw_id' => connection.access_mac, 'client_id' => connection.token,'status' => 'online' })
                puts http.request(req).body
             end
          end
         end
      when 'counters'
        if !connection.expired?
          auth = 1
          connection.update_attributes({
            :mac => params[:mac],
            :ipaddr => params[:ip],
            :incoming => params[:incoming],
            :outgoing => params[:outgoing],
            :status => "ping"
          })                        
          end
      when 'logout'
        logger.info "Logging out: #{params[:token]}"
          connection.update_attributes({
            :status => "ping"
          })                        
        connection.expire!
        url = URI.parse('http://www.rubyinside.com/test.cgi')
        Net::HTTP.start(url.host, url.port) do |http|
             req = Net::HTTP::Post.new(url.path)
             req.set_form_data({ 'gw_id' => connection.access_mac, 'client_id' => connection.token,'status' => 'offline' })
             puts http.request(req).body
        end
      else          
        logger.info "Invalid stage: #{params[:stage]}"
      end    
    end
    "Auth: #{auth}"
  end

  def self.logout(params)
    connection = self.find_by_token(params[:token]);
    if connection.nil? or !connection.expire!
      false
    else  
      connection
    end
  end

  def self.sign_out(params)
    connection = self.find_by_token(params[:client_id]);
    if connection.nil? or !connection.expire!
      false
    else  
      connection
    end
  end


end
