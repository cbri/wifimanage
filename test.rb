require 'net/http'
require 'json'    
params = {}  
params["ip"] = '117.34.78.196'  
uri = URI.parse("http://ip.taobao.com/service/getIpInfo.php")  
res = Net::HTTP.post_form(uri, params)   
  
puts res.header['set-cookie']  
puts res.body 
h = JSON.parse res.body
ss= h["data"]["country"]
ss.encode!("GB18030")
p ss
p ss.encode("utf-8")          
