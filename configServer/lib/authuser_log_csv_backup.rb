#transfer daily connection data to ftp server every next day.  
#please make sure the execution time of this script is after 0:0:0 each day.


require 'rubygems'
require 'mysql2'  
require 'net/ftp'
  
LOCAL_BACKUP_BASE_DIR = '/var/lib/mysql/wificonndata/'
DB_NAME = "authpuppy_production"
DB_HOST = 'localhost'
DB_USER = "root"
DB_PASSWD = 'ctbri@2014'

FTP_SERVER_HOST = '218.94.58.242'
FTP_REMOTE_DIR = '/opt/bssusers/'
FTP_USER = 'bssuser'
FTP_PASSWD = 'jswifipo)('

con = Mysql2::Client.new(:host => DB_HOST, :username => DB_USER, :password => DB_PASSWD, :database => DB_NAME )
filename = "userlog#{ Time.now.strftime("%Y%m%d%H%M%S") }.csv"

 
con.query("SELECT phonenum,created_at,expired_on,mac,access_mac,device INTO OUTFILE '#{ LOCAL_BACKUP_BASE_DIR + filename }'  FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ESCAPED BY '\\\\' LINES TERMINATED BY '\\n' FROM connections WHERE created_at >=  TIMESTAMP( DATE(DATE_SUB(now(),INTERVAL 1 DAY))) AND created_at < TIMESTAMP( DATE(now())) ")  

con.close

  
ftp = Net::FTP.new( FTP_SERVER_HOST  )
ftp.passive = true
ftp.login( FTP_USER , FTP_PASSWD )

files = ftp.chdir( FTP_REMOTE_DIR )

#ftp.puttextfile( "#{ LOCAL_BACKUP_BASE_DIR + filename }" )

ftp.putbinaryfile( "#{ LOCAL_BACKUP_BASE_DIR + filename }" )
ftp.close
