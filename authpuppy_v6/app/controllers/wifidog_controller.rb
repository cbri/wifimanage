# encoding: utf-8
class WifidogController < ApplicationController
  before_filter :garbage_collect

  def back_code(code)
    respond_to do |format|
      format.json {render :json => {:result =>code["result"],:code =>code["code"],:message =>code["message"]}}
    end
  end

  def back_task(code)
    if code["task_code"]=="3000"
      respond_to do |format|
       format.json {render :json => {:task => {:task_code=>code["task_code"].to_i, :task_id=>code["task_id"],:task_params =>{ :file =>code["task_params"]} },:result =>code["result"],:code =>code["code"],:message =>code["message"]}}
       str = "{\"result\":\"#{code["result"]}\","
       str += "\"code\":\"#{code["code"]}\","
       str += "\"message\":\"#{code["message"]}\","
       str += "\"task\":{\"task_code\":#{code["task_code"]},\"task_id\":\"#{code["task_id"]}\",\"task_params\":{\"file\":\"#{code["task_params"]}\"}}"
       str +="}"
       format.html {render text: str}
      end
    elsif code["task_code"]=="2003"
      params = code["task_params"]
      ssid=""
      hostname=""
      if params.include? "ssid:"
         ssid=params.gsub(/ssid:/,"")
      elsif params.include? "hostname:"
         hostname = params.gsub(/hostname:/,"")
      else
         ssid=params
      end
      respond_to do |format|
       format.json {render :json => {:task => {:task_code=>code["task_code"].to_i, :task_id=>code["task_id"],:task_params =>{ :ssid =>ssid,:hostname=>hostname }},:result =>code["result"],:code =>code["code"],:message =>code["message"]}}
       str = "{\"result\":\"#{code["result"]}\","
       str += "\"code\":\"#{code["code"]}\","
       str += "\"message\":\"#{code["message"]}\","
       str += "\"task\":{\"task_code\":#{code["task_code"]},\"task_id\":\"#{code["task_id"]}\",\"task_params\":{\"ssid\":\"#{ssid}\",\"hostname\":\"#{hostname}\"}}"
       str +="}"
       format.html {render text: str}
      end
    elsif code["task_code"]=="10000"
      params = code["task_params"]
      respond_to do |format|
       pjson = JSON.parse params
       format.json {render :json => {:task => {:task_code=>code["task_code"].to_i, :task_id=>code["task_id"],:task_params =>pjson },:result =>code["result"],:code =>code["code"],:message =>code["message"]}}

       str = "{\"result\":\"#{code["result"]}\","
       str += "\"code\":\"#{code["code"]}\","
       str += "\"message\":\"#{code["message"]}\","
       str += "\"task\":{\"task_code\":#{code["task_code"]},\"task_id\":\"#{code["task_id"]}\",\"task_params\":#{params}}"
       str +="}"
       format.html {render text: str}
     end
    else
     respond_to do |format|
       format.json {render :json => {:task => {:task_code=>code["task_code"].to_i, :task_id=>code["task_id"],:task_params =>{} },:result =>code["result"],:code =>code["code"],:message =>code["message"]}}
     
       str = "{\"result\":\"#{code["result"]}\","
       str += "\"code\":\"#{code["code"]}\","
       str += "\"message\":\"#{code["message"]}\","
       str += "\"task\":{\"task_code\":#{code["task_code"]},\"task_id\":\"#{code["task_id"]}\",\"task_params\":{}}"
       str +="}"
       format.html {render text: str}
     end
    end
  end

  def ping
    render :text => AccessNode.ping(params,request)
  end

  def ping_zj
    render :text => AccessNode.ping_zj(params,request)
  end

  def ping_task
    render :text => AccessNode.ping_task(params,request)
  end

  def retrieve
    render :text => AccessNode.retrieve(params)
  end

  def fetchconf
    render :text => AccessNode.fetchconf(params)
  end
  
  def taskresult
    if params[:dev_id]
       task=Task.find_by_task_id(params[:task_id])
       task.update_attributes( :status => "2",:result=>params[:result] )
    end
    respond_to do |format|
      format.json {render :json => {:result =>"OK",:message =>""}}
    end
  end

  def taskrequest
    code=AccessNode.taskrequest(params)
    if code["task_id"]
      back_task(code)
    else
      back_code(code)
    end
  end

  def setconfigflag
    render :text => AccessNode.setconfigflag(params)
  end

  def denied
    render :text=>"Denied Action", :status => 404
  end

  def auth
    render :text => Connection.authupdate(params)
  end

  def auth_zj
    render :text => Connection.authupdate_zj(params)
  end

  def login
    device = request.user_agent.downcase
    token=SecureRandom.urlsafe_base64(nil, false)
    logger.info token
    node = AccessNode.find_by_dev_id(params[:dev_id])
    mac = ""
    if params[:mac]
      mac = params[:mac].gsub(/[:-]/, "").upcase
    end
    if node
        logger.info token
        time = Time.now+30.minutes
        if !node.time_limit.nil? and node.time_limit > 0
           time= Time.now+node.time_limit.minutes
        end
        login_connection = Connection.create!(:token => token,
                                            :access_mac => node.mac,
                                            :access_node_id => node.id,
                                            :expired_on => time,
                                            :mac => mac,     
                                            :device=> device                             
                                            )
    end
    respond_to do |format|
      if params[:callback]
       auth_url=""
       if node.auth_plattype==1
           auth_url="http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
        else
          if node.auth_plattype==2
            auth_url="http://#{params[:gw_address]}:#{params[:gw_port]}/smartwifi/auth?token=#{token}&url=#{params[:url]}"

          else
            auth_url= "http://#{params[:gw_address]}:#{params[:gw_port]}/ctbrihuang/auth?token=#{token}"
          end
       end
       str= params[:callback]+"({result:\"OK\",token:\"#{token}\",auth_url:\"#{auth_url}\"})"
       format.html {render text: str}
      else
       format.json {render :json => {:result =>"OK",:token => token}}
      end
    end
  end
  def upload
    if params[:dev_id]
      if params[:compression].include?
          self.transaction do
            params[].each do item
            
            end
          end
      end
    end
  end
end
