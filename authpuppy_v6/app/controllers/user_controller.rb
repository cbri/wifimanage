# encoding: utf-8
class UserController < ApplicationController
  #layout "special",:only=>[:login_zj]
  layout "special",:only=>[:portal_zj]
  layout "special",:only=>[:portal_ict]
  def login
    redirect_to AccessNode.login(params) 
  end 
  

  def authenticate
      device = request.user_agent.downcase
      redirect_to  AccessNode.authenticate(params,device)
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
  end
  
  def portal_ict
  end

end
