require 'rubygems'
require 'rufus/scheduler'
require 'net/http'
scheduler = Rufus::Scheduler.new

scheduler.every("30s") do
   puts Time.now
   nodes = AccessNode.where("last_seen < ? and last_seen > ? ",Time.now - 60, Time.now - 600) 
   pingnodes = AccessNode.where("last_seen < ? and last_seen > ? and status = 'ping'",Time.now - 60, Time.now - 600) 
   pingnodes.each do |pingnode|
     url = URI.parse('http://www.rubyinside.com/test.cgi')
     Net::HTTP.start(url.host, url.port) do |http|
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data({ 'gw_id' => pingnode.gw_id, 'status' => 'offline' })
     puts http.request(req).body
     end
     pingconns = pingnode.online_connections 
     pingconns.each do |pingconn|
        url = URI.parse('http://www.rubyinside.com/test.cgi')
        Net::HTTP.start(url.host, url.port) do |http|
          req = Net::HTTP::Post.new(url.path)
          req.set_form_data({ 'gw_id' => pingnode.gw_id,'client_id' => pingconn.token, 'status' => 'offline' })
          puts http.request(req).body
        end
        pingconn.update_attributes({
           :status => "offline"
        })                        
     end
     pingnode.update_attributes({
       :status => "offline"
     })                        
   end
   
   puts nodes.count
   nodes.each do |node|
     connections = node.online_connections 
     connections.each do |connection|
       connection.expire!
     end
   end
end
scheduler.every("60s") do
   pingconns = Connection.where("updated_at< ?  and status = 'ping'",Time.now-130)
   pingconns.each do |pingconn|
        url = URI.parse('http://www.rubyinside.com/test.cgi')
        Net::HTTP.start(url.host, url.port) do |http|
          req = Net::HTTP::Post.new(url.path)
          req.set_form_data({ 'gw_id' => pingconn.access_mac,'client_id' => pingconn.token, 'status' => 'offline' })
          puts http.request(req).body
        end
        pingconn.update_attributes({
           :status => "offline"
        })                        
   end
   connections = Connection.where("updated_at< ?  and expired_on > ?",Time.now-130,Time.now) 
   connections.each do |connection|
       connection.expire!
   end
   
end
