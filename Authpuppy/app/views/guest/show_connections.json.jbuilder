Jbuilder.encode do |json|
  json.connections @connections do |connection|
    json.mac connection.mac
    json.expired_on connection.expired_on
    json.incoming connection.incoming
    json.outgoing connection.outgoing
  end
end
