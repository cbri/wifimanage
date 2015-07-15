# encoding: utf-8
require 'openssl'
require 'base64'
require 'uri'
class UserController < ApplicationController
  #layout "special",:only=>[:login_zj]
  layout "special",:only=>[:portal_zj]
  layout "special",:only=>[:portal_ict]
  layout "special",:only=>[:defriending]
  def login
    redirect_to AccessNode.login(params) 
  end 
  def back_json(code,msg,token,auth_url)
    respond_to do |format|
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg,:token => token,:auth_url=>auth_url }}}
    end
  end 

  def authenticate
      device = request.user_agent.downcase
      check=  AccessNode.authenticate(params,device)
      if check[:check]
        back_json(check[:code],check[:msg],check[:token],check[:auth_url]);
      else
        redirect_to check
      end 
  end

  def portal
    redirect_to AccessNode.portal(params)
  end

  def logout
    @connection = Connection.logout(params);
    if !@connection
      render :text=> "Empty Offline"
    else  
      respond_to do |format|  
        format.html { render :text=>"Success Offline" }
        format.js { render :layout=>false }
      end
    end
  end

  def freeland
    check = AccessNode.freeland params
    unless check[:check]
      render :text=> "Code:#{check[:code]} Msg:#{check[:msg]}"
    else 
      render :text=> check[:msg]
    end
  end
  
  def login_zj
    if request.get?
      node = AccessNode.find_by_dev_id(params[:dev_id])
      if node and !node.redirect_url.blank?
        redirect_to AccessNode.login_zj(params)   
      end
    else
      dev_id=''
      session_id=0
      re = {}
      if params[:params]
        param= params[:params]
        param=param.delete "\n"
        de_cipher = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
        de_cipher.decrypt
        key = "01234567890123456789012345678912"
        de_cipher.key = key
        str=Base64.decode64(param)
        text=(de_cipher.update(str) << de_cipher.final)
        logger.info(text)
        tjson = JSON.parse text
        session_id=tjson["session_id"]
        url=tjson["url"]
        url=url.delete "\\"
        querys = URI.parse(url).query.split("&")
        querys.each do | query |  
          query_arr = query.split("=")  
          re[query_arr[0]]=query_arr[1]  
        end 
        dev_id=re["dev_id"] 
        logger.info dev_id      
      end
      node = AccessNode.find_by_dev_id(dev_id)
      if node
        device = request.user_agent.downcase
        token=SecureRandom.urlsafe_base64(nil, false)
        curcon=Connection.find(:first, :conditions => ["mac = ? and expired_on > NOW()",re["client_mac"]])
        if curcon
           token=curcon.token
        else
          if !node.time_limit.nil? and node.time_limit > 0
            login_connection = Connection.create!(:token => token,
                                                :phonenum => re["client_mac"],
                                                :access_mac => re["gw_id"],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+node.time_limit.minutes,
                                                :portal_url => re["url"]
                                               )
          else
            login_connection = Connection.create!(:token => token,
                                                :phonenum => re["client_mac"],
                                                :access_mac => re["gw_id"],
                                                :device => device,
                                                :access_node_id => node.id,
                                                :expired_on => Time.now+30.minutes,
                                                :portal_url => re["url"]
                                               )
          end
        end
        auth_url=""
        if node.auth_plattype==2 
          auth_url="http://#{re["gw_address"]}:#{re["gw_port"]}/smartwifi/auth?token=#{token}"
        else
          auth_url="http://#{re["gw_address"]}:#{re["gw_port"]}/ctbrihuang/auth?token=#{token}"
        end
        str="{\"api_code\":1,\"session_id\":#{session_id}"
        str+=",\"ad_url\":\"#{node.portal_url}\""
        str+=",\"auth_url\":\"#{auth_url}\""
        str+="}"
        en_cipher = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
        en_cipher.encrypt
        en_cipher.key = "01234567890123456789012345678912"
        cipher = en_cipher.update(str)
        cipher << en_cipher.final 
        stren = Base64.encode64(cipher)
        logger.info str
        logger.info stren
        logger.info session_id
        respond_to do |format|
         pjson = JSON.parse str
         #format.json {render :json =>pjson}
         format.html {render text: stren}
        end       
      end
    end
  end

  def portal_zj
    node = AccessNode.find_by_dev_id(params[:dev_id])
    if node and !node.portal_url.blank?
      redirect_to AccessNode.portal_zj(params)
    end
  end
  
  def portal_ict
  end

  def defriending
      wx=Weixin_Friend.find_by_mac(params[:mac])
      if wx
         wx.update_attributes( :isFriend => 0 );
      end
      respond_to do |format|  
        format.html { render :text=>"Success Offline" }
        format.js { render :layout=>false }
      end
      connections=Connection.where("mac=? and expired_on > NOW() ",params[:mac] )
      connections.each do |connection|
         connection.expire!
      end
  end

  def sign_out
    if params[:client_id].nil?
         status_json(4002003,"Paramters client_id is error")
         return
    end
    @connection = Connection.sign_out(params);
    if !@connection
      status_json(4002003,"client_id is not existing")
    else
      status_json(200,"success")
    end
  end

  def status_json(code,msg)
      respond_to do |format|
         format.json {render :json => {:status => {:code=>code.to_s, :message=>msg }}}
      end
  end

end
