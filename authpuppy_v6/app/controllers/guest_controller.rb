# encoding: utf-8
class GuestController < ApplicationController
  before_filter :check_params,:except => [:edit,:update,:setap]

  def back_code(code,msg)
    respond_to do |format|
      format.html {render text: "{\"status\":{\"code\":\"#{code.to_s}\",\"message\":\"#{msg}\"}}"}
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg }}}
    end
  end

  def check_params
    logger.info params
    if params[:username].nil? or params[:password].nil?
      back_code(101,"Missing Some Params") 
    elsif !Guest.auth_guest(params[:username],params[:password])
      back_code(103,"Auth Error") 
    end
  end
  
  def edit
   @guest =Guest.find(params[:id])
   if @guest
     roam =Roam.find_by_guest_id(params[:id])
     if roam
      @guest.roam=roam.roam
     end
   end
  end

  def update
    @guest = Guest.find(params[:id]);
    temp=params[:guest]
    value=temp["roam"].to_i
    @guest.roam=value
    roam=Roam.find_by_guest_id(params[:id]);
    if roam.nil?
      Roam.create!(:guest_id=>params[:id],:roam=>value)
      render :action => "edit"
    else
      if roam.update_attributes(:roam=>value)
        redirect_to :action => "edit"
      else
        render :action => "edit"
      end
    end
  end

  def show_connections
    check = AccessNode.show_connections(params[:mac])
    if check[:check]
      @connections, @status = check[:conn], check[:status]
    else
      back_code(check[:code],check[:msg]);
    end
  end
  
  def setap
    check = AccessNode.setap(params)
    if check[:check]
        back_code(check[:code],check[:msg])
    else
        back_code(check[:code],check[:msg])
    end
  end
  def self.define_component(name)
    define_method(name) {
      check = AccessNode.send name, params
      if check[:check]
        back_code(check[:code],check[:msg])
      else
        back_code(check[:code],check[:msg])
      end 
    }
  end
  
  
  define_component  :update_auth_type
  define_component  :update_auth_device
  define_component  :update_access_time
  define_component  :update_cmdline
  define_component  :update_ssid
  define_component  :update_conf
  define_component  :update_publicip
  define_component  :bindurl
  define_component  :create_address
  define_component  :addnodes
  define_component  :update_trustedmacs
end
