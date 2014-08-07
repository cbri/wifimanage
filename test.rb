require 'net/http'  
params = {}  
params["gw_id"] = '048D3844F5E0'  
uri = URI.parse("http://124.127.116.181/setconfigflag")  
res = Net::HTTP.post_form(uri, params)   
  
puts res.header['set-cookie']  
puts res.body 
