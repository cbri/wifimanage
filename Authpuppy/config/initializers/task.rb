require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.every("30s") do
   puts Time.now
   nodes = AccessNode.where("last_seen < ? and last_seen > ? ",Time.now - 60, Time.now - 600) 
   puts nodes.count
   nodes.each do |node|
     connections = node.online_connections 
     connections.each do |connection|
       connection.expire!
     end
   end
end
scheduler.every("60s") do
   connections = Connection.where("updated_at< ?  and expired_on > ?",Time.now-60,Time.now) 
   connections.each do |connection|
       connection.expire!
   end
end
