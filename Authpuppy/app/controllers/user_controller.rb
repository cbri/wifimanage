# encoding: utf-8
class UserController < ApplicationController

  def back_code(code,msg)
    respond_to do |format|
      format.html {render text: "Error#{code.to_s}-#{msg}"}
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg,:server => "124.127.116.181" }}}
    end
  end
  
  def back_json(code,msg,token)
    respond_to do |format|
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg,:token => token }}}
    end
  end

  def login
    redirect_to AccessNode.login(params) 
  end 
  
  def authenticate_old
      device = request.user_agent.downcase
      redirect_to  AccessNode.authenticate_old(params,device)
  end

  def authenticate
    device = request.user_agent.downcase
    check =AccessNode.authenticate(params,device)
    begin
      if check[:check]
        back_json(check[:code],check[:msg],check[:token]);
      else
        back_json(check[:code],check[:msg],"");     
      end
    rescue Exception => e
        puts e.to_s
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

  def sign_out
    @connection = Connection.sign_out(params);
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
  
  
  def status_json(code,msg)
      respond_to do |format|
         format.json {render :json => {:status => {:code=>code.to_s, :message=>msg }}}
      end
  end

  def client_status
      if params[:client_id].nil? 
         status_json(4002003,"Paramters client_id is error")
         return
      end
      conn = Connection.find(:first, :conditions => ['token = ?', params[:client_id]])
      if conn
         if conn.expired?
            status_json(200,"offline")           
         else
            status_json(200,"online")
         end
      else
         status_json(400201,"client is not to exist")
      end
  end

end
