#!/usr/bin/env python
import sys
import MySQLdb
import json

try:
     
    input = file("/home/smartwifi/fluent_exec/log")
    for line in input:
        print line       
        encoded = json.loads(unicode(line , errors='ignore'))
        dev_id=encoded['dev_id']
        logs = encoded['logs']
        for log in logs:
          values=[]
          values.append(dev_id)
          values.append(log['time'])
          values.append(log['user'])
          values.append(log['client_mac'])
          values.append(log['log_type'])
          values.append(log['log_value'])
 
 
 
except Exception ,e:
     print "33"
#input = file(sys.argv[-1])
#output = file("foobar.out", "a")
#for line in input:
#    output.write(line)
#output.close
