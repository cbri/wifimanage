require 'rubygems'
require 'rufus/scheduler'
require 'net/http'
scheduler = Rufus::Scheduler.new

scheduler.every("30s") do
   puts Time.now
   nodes = AccessNode.where("last_seen < ? and last_seen > ? ",Time.now - 60, Time.now - 600) 
   pingnodes = AccessNode.where("last_seen < ? and last_seen > ? and status = 'ping'",Time.now - 60, Time.now - 600) 
   observernodes = Observer.where("type = 1 ") 
   observerconns = Observer.where("type = 2 ") 
   pingnodes.each do |pingnode|
     observernodes.each do |observernode|
        url = URI.parse(observernode.url)
        Net::HTTP.start(url.host, url.port) do |http|
          req = Net::HTTP::Post.new(url.path)
          req.set_form_data({ 'gw_id' => pingnode.gw_id, 'status' => 'offline' })
          puts http.request(req).body
        end
     end
     pingconns = pingnode.online_connections 
     pingconns.each do |pingconn|
        observerconns do |observerconn|
          url = URI.parse(observerconn.url)
          Net::HTTP.start(url.host, url.port) do |http|
            req = Net::HTTP::Post.new(url.path)
            req.set_form_data({ 'gw_id' => pingnode.gw_id,'client_id' => pingconn.token, 'status' => 'offline' })
            puts http.request(req).body
          end
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
   pingconns = Connection.where("updated_at< ?  and status = 'ping'",Time.now-120)
   observerconns = Observer.where("type = 2 ") 
   pingconns.each do |pingconn|
        observerconns.each do |observerconn|
           url = URI.parse(observerconn.url)
           Net::HTTP.start(url.host, url.port) do |http|
             req = Net::HTTP::Post.new(url.path)
             req.set_form_data({ 'gw_id' => pingnode.gw_id,'client_id' => pingconn.token, 'status' => 'offline' })
             puts http.request(req).body
           end
        end
        pingconn.update_attributes({
           :status => "offline"
        })                        
        pingnode.update_attributes({
         :status => "offline"
        })                        
   end
   connections = Connection.where("updated_at< ?  and expired_on > ?",Time.now-60,Time.now) 
   connections.each do |connection|
       connection.expire!
   end
   
end
