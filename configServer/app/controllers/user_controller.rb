# encoding: utf-8
class UserController < ApplicationController
  #layout "special",:only=>[:login_zj]
  layout "special",:only=>[:portal_zj]
  layout "special",:only=>[:portal_ict]
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
    node = AccessNode.find_by_dev_id(params[:dev_id])
    if node and !node.redirect_url.blank?
      redirect_to AccessNode.login_zj(params)   
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
