# encoding: utf-8
class UploadController < ApplicationController
  def index
  end
  def uploadFile
    directory = 'public/data'
    name = params[:image].original_filename
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:image].read) }
    render :text => "File has been uploaded successfully"
  end

  def download
    sql = ActiveRecord::Base.connection()  
    current_guest ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    if current_guest and current_guest.name=="admin"
       @access_nodes = AccessNode.all();
    end 
    Spreadsheet.client_encoding ="UTF-8"   
    book = Spreadsheet::Workbook.new 
    sheet1 = book.create_worksheet
    file = "#{current_guest.name}_#{Time.now.strftime("%m%d%G%s")}_forecast.xls"
    if current_guest and current_guest.name!="admin"
       @access_nodes = AccessNode.where(:guest_id =>current_guest.id);
    end
    sheet1.name='统计信息'
    sheet1.update_row(0,'AP总数',@access_nodes.size())
    i=0
    sheet2 = book.create_worksheet
    sheet2.name='上网信息'
    j=0
    @access_nodes.each do |access_node|
         cmd="select sum(TIMESTAMPDIFF(minute,created_at,updated_at)) as duration, COALESCE(sum(incoming),0)/1024 as incoming,COALESCE(sum(outgoing),0)/1024 as outgoing,phonenum from connections where phonenum is NOT null and   access_mac = '"
         cmd+=access_node.mac
         cmd+="'GROUP by phonenum"
         values = sql.select(cmd)
         if values.size >0
           i=i+1
           sheet1.update_row(i,'AP名称',access_node.name)
           i=i+1
           sheet1.update_row(i,'连接用户数',values.size())
           i=i+1
           sheet1.update_row(i,'AP名称','号码','上网总时长(分钟)','总上行流量(KB)','总下行流量(KB)')
         end
         values.each do |value|
           logger.info value
           if value['duration']
             i+=1
             sheet1.update_row(i,access_node.name,value['phonenum'],value['duration'],value['incoming'],value['outgoing'])
           end
         end
         cmd="select created_at as start_time,TIMESTAMPDIFF(minute,created_at,updated_at) as duration, COALESCE(incoming,0)/1024 as incoming,COALESCE((outgoing),0)/1024 as outgoing,phonenum from connections where phonenum is NOT null and   access_mac = '"
         cmd+=access_node.mac
         cmd+="'ORDER BY phonenum"
         values = sql.select(cmd)
         if values.size >0
           j=j+1
           sheet2.update_row(j,'AP','号码','上网时间','上网时长(分钟)','上行流量(KB)','下行流量(KB)')
         end
         values.each do |value|
           logger.info value
           if value['duration']
             j+=1
             sheet2.update_row(j,access_node.name,value['phonenum'],value['start_time'],value['duration'],value['incoming'],value['outgoing'])
           end
         end
    end
    
    file_path = "public/data"
    epath=File.join(file_path, file)
    logger.info epath
    book.write(epath)
      if File.exist?(epath)
        #@system_uploadfile.add_download_count
        #send_file file_path,:disposition => 'inline'
        io = File.open(epath)
        io.binmode
        send_data(io.read,:filename => file,:disposition => 'attachment')
        io.close
      else
        render :text => "File has been download fail"
      end
  end

  def getpack
    
    name = params["name"]
    file_path = "public/data"
    epath=File.join(file_path, name)
      if File.exist?(epath)
        #@system_uploadfile.add_download_count
        #send_file file_path,:disposition => 'inline'
        io = File.open(epath)
        io.binmode
        send_data(io.read,:filename => file,:disposition => 'attachment')
        io.close
      else
        render :text => "File has been download fail"
      end
  end

end
