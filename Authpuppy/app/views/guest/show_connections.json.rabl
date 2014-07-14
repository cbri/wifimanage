object false

child @AP => :AP do
  attributes :online_duration,:incoming,:outgoing
end
child @connections,:object_root => false do
  attributes :id, :mac, :expired_on, :created_at, :phonenum, :incoming, :outgoing
end

child @status => :status do
  attributes :code, :message
end

