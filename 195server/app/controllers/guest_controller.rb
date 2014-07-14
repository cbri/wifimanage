# encoding: utf-8
require 'httparty'

class GuestController < ApplicationController
  before_filter :check_params

  @@servernum = 0;  

  def back_code(code,msg)
    respond_to do |format|
      format.html {render text: "Error#{code.to_s}-#{msg}"}
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg}}}
    end
  end

  def check_params
    if params[:username].nil? or params[:password].nil?
      back_code(101,"Missing Some Params") 
    elsif !Guest.auth_guest(params[:username],params[:password])
      back_code(103,"Auth Error") 
    end
  end

  def back_json(code,msg,serverIP)
    respond_to do |format|
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg,:serverIP => serverIP }}}
    end
  end



    #i = @@servernum/2

    #result = HTTParty.post("http://#{server[i]}/bindurl.json",
    #                      :body => params.to_json,
    #                        :headers => { 'Content-Type' => 'application/json' }
    #                     )
    #@@servernum++
    #if result["status"]["code"] == "200"
    #  check =  AccessNode.createnode  params, server[0]
    #  back_code(check[:code],check[:msg])
    #else
    #   render :json => result
    #end
 

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

  
  def self.define_show(name)
    define_method(name) {
      check = AccessNode.send name, params
      if check[:check]
        @results, @status = check[:results], check[:status]
      else
        back_code(check[:code],check[:msg])
      end 
    }

  end

  def self.define_component_json(name)
    define_method(name) {
      check = AccessNode.send name, params
      if check[:check]
        back_json(check[:code],check[:msg],check[:serverIP])
      else
        back_json(check[:code],check[:msg],"")
      end
    }
  end
  
  define_component  :update_auth_type
  define_component  :update_auth_device
  define_component  :update_access_time
  define_component  :bindurl
  define_component  :update_portal_url
  define_component_json  :addnodes
  define_show  :show_nodes
  define_show  :show_node
  define_show  :show_connections

end
