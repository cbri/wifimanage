#!/usr/bin/env python
import sys
import MySQLdb
import json

try:
    conn=MySQLdb.connect(host='42.123.76.28',user='root',passwd='ctbri@2014',port=3306)
    cur=conn.cursor()
     
    conn.select_db('yunwifi_production')
    input = file(sys.argv[-1])
    for line in input:
      try:     
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
          cur.execute('insert into logs (dev_id,time,user,client_mac,log_type,log_value) values(%s,%s,%s,%s,%s,%s)',values)
 	
      except Exception ,e:
         print e
    conn.commit()
    cur.close()
    conn.close()
 
except MySQLdb.Error,e:
     print "Mysql Error %d: %s" % (e.args[0], e.args[1])
#input = file(sys.argv[-1])
#output = file("foobar.out", "a")
#for line in input:
#    output.write(line)
#output.close
