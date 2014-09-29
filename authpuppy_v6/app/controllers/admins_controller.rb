#encoding: utf-8
require 'json'
class AdminsController < ApplicationController
  layout "special",:only=>[:register]
  layout "special",:only=>[:addnode]
  def login
    cookies.delete(:token)
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "已经退出登录"
  end

  def create_login_session
    admin = Admin.find_by_name(params[:name])
    guest = Guest.find_by_name(params[:name])
    if guest
      logger.info guest.name
    end
    password =  params[:password]
    logger.info password
    if admin && admin.authenticate(params[:password])
      cookies.permanent[:token] = admin.token
      redirect_to access_nodes_url, :notice => "登录成功"
    elsif guest && guest.authenticate(password)
      logger.info "OOO11122"
      cookies.permanent[:token] = guest.token
      redirect_to access_nodes_url, :notice => "登录成功"
      
    else
      flash[:notice] = "无效的用户名和密码"
      redirect_to :action => "login"
    end
  end
   
  def usernamevalidation
    guest=Guest.find_by_name(params[:username]);
    if guest.nil?
       respond_to do |format|
         format.html {render text: "OK"}
         format.json {render :json => {:result => "OK"}}
       end
    else
      respond_to do |format|
         format.html {render text: "fail"}
         format.json {render :json => {:result => "fail"}}
      end
    end
  end
 
  def devicenamevalidation
    node=AccessNode.find_by_name(params[:devicename]);
    if node.nil?
       respond_to do |format|
         format.html {render text: "OK"}
         format.json {render :json => {:result => "OK"}}
       end
    else
      respond_to do |format|
         format.html {render text: "fail"}
         format.json {render :json => {:result => "fail"}}
      end
    end
  end

  def register
    if request.post?
       node = AccessNode.find_by_mac(params[:gw_mac])
       dev_id=SecureRandom.hex(16)
       if node.nil?
          node = AccessNode.create!(mac:params[:gw_mac],name:params[:gw_mac],belong_type:1,dev_id:dev_id)
          Auth.create!(auth_type:"radius",auth_device:false,access_node_id:node.id)
          Conf.create!(access_node_id:node.id)
       end
       if node.dev_id.nil?
          node.update_attributes(:dev_id => dev_id)
       else
          dev_id = node.dev_id
       end
       ad = Address.where(:access_node_id => node.id).first
       geoLocation = JSON.parse params[:geoLocation]
       city= geoLocation["city"]
       province= geoLocation["province"]
       district= geoLocation["county"]
       detail= geoLocation["address"]
       city_id=""
       province_id=""
       district_id=""
       aprov = Addr_province.where([ "name like ?", province+"%"]).first
       if aprov
          province_id = aprov.code
          if province_id=="110000"
          else
             acity = Addr_city.where([ "name like ? and province_code = ?", city+"%", province_id]).first
             if acity
                city_id= acity.code
	     
                adist = Addr_district.where([ "name like ? and city_code = ?", district+"%", city_id]).first
                if adist
                  district_id = adist.code
                end
             end
          end
       end
       if ad.nil?
          Address.create!(access_node_id:node.id,city:city_id,detail:detail,province:province_id,district:district_id)
       else
          ad.update_attributes(
                 :city => city_id,
                 :province => province_id,
                 :district => district_id
              )
       end
       
       respond_to do |format|
          format.html {render text: "Error#{code.to_s}-#{msg}"}
          format.json {render :json => {:result=>"OK", :message=>"OK",:dev_id => dev_id }}
       end
    else
       if params["stage"]
         node = AccessNode.find_by_mac(params[:mac])
         dev_id="";
         if node
            dev_id= node.dev_id
         end
         str="{\"result\":\"OK\",\"services\":{\"device_id\":\"#{dev_id}\",\"account\":\"\",\"active_date\":\"#{Time.now}\","
         str+="\"servers\": {\"portals\": [{\"hostname\": \"42.123.76.18\",\"ssl_available\": \"no\",\"ssl_port\": \"443\", \"http_port\": \"80\",\"path\": \"\/api10\/\" }],"
         str+="\"auths\": [ {\"hostname\": \"42.123.76.18\",\"ssl_available\": \"no\",\"ssl_port\":\"443\",\"http_port\": \"80\", \"path\": \"\/api10\/\"} ],"
         str +="\"platforms\": [ {\"hostname\": \"42.123.76.18\", \"ssl_available\": \"no\", \"ssl_port\": \"443\", \"http_port\": \"80\",\"path\": \"\/api10\/\" }] } }}"
         respond_to do |format|
          format.json {render :json => {:result=>"OK", :message=>"OK",:services => {:device_id => dev_id,:account =>"",:active_date=>Time.now,:servers=>{:portals=>[{:hostname=>"42.123.76.18",:ssl_available=>"no",:ssl_port=>"443",:http_port=>"80",:path=>"/api10/"}],:auths=>[{:hostname=>"42.123.76.18",:ssl_available=>"no",:ssl_port=>"443",:http_port=>"80",:path=>"/api10/"}],:platforms=>[{:hostname=>"42.123.76.18",:ssl_available=>"no",:ssl_port=>"443",:http_port=>"80",:path=>"/api10/"}]} } }}
          format.html {render text: str}
         end
       end
    end
  end
  def addnode
    if request.post?
       bok=true
       message="Ok"
       result="OK"
       if params[:registeraccount] != "true"
          guest = Guest.where(:name => params[:username]).first
          bok=false
          message="用户名不存在"
          result="fail"
          if guest.nil?
            respond_to do |format|
              format.html {render text: message}
              format.json {render :json => {:result=>result, :message=>message,:dev_id => dev_id }}
            end
             
          end
       end
       logger.info "testteststest"
       mac = params[:gw_mac]
       if mac
         mac.gsub!(/[:-]/, "").upcase
         mac.lstrip!
         mac.rstrip! 
       end
       node = AccessNode.find_by_mac(params[:gw_mac])
       dev_id=SecureRandom.hex(16)
       if node.nil?
          node = AccessNode.create!(mac:mac,name:params[:name],belong_type:1,dev_id:dev_id,portal_url:params[:portal_url],redirect_url:params[:redirect_url])
          Auth.create!(auth_type:"local",auth_device:false,access_node_id:node.id)
          Conf.create!(access_node_id:node.id)
       else
          node.update_attributes(:name => params[:name],:portal_url => params[:portal_url], :redirect_url=>params[:redirect_url])
       end
       if node.dev_id.nil?
          node.update_attributes(:dev_id => dev_id)
       else
          dev_id = node.dev_id
       end
       if params[:registeraccount] == "true"
               
         ad = Address.where(:access_node_id => node.id).first
         geoLocation = JSON.parse params[:geoLocation]
         city= geoLocation["city"]
         province= geoLocation["province"]
         district= geoLocation["county"]
         detail= geoLocation["address"]
         city_id=""
         province_id=""
         district_id=""
         aprov = Addr_province.where([ "name like ?", province+"%"]).first
         if aprov
            province_id = aprov.code
            if province_id=="110000"
               acity = Addr_city.where([ "name like ? and province_code = ?", province+"%", province_id]).first
               if acity
                  city_id= acity.code

                  adist = Addr_district.where([ "name like ? and city_code = ?", city+"%", city_id]).first
                  if adist
                    district_id = adist.code
                  end
               end
            else
               acity = Addr_city.where([ "name like ? and province_code = ?", city+"%", province_id]).first
               if acity
                  city_id= acity.code

                  adist = Addr_district.where([ "name like ? and city_code = ?", district+"%", city_id]).first
                  if adist
                    district_id = adist.code
                  end
               end
            end
         end
         if ad.nil?
            ad =  Address.create!(access_node_id:node.id,city:city_id,detail:detail,province:province_id,district:district_id)
         else
            ad.update_attributes(
                 :city => city_id,
                 :province => province_id,
                 :district => district_id,
                 :detail => detail
              )
         end
         contact = Contact.where(:access_node_id => node.id).first
         if contact.nil?
           contact = Contact.create!(access_node_id:node.id,merchant:params[:merchantName],name:params[:contact],phonenum:params[:cellNumber],telephonenum:params[:telephone],email:params[:email],weixin:params[:weixin],node_mac:mac)
         else
           contact.update_attributes(
                 :merchant => params[:merchantName],
                 :name => params[:contact],
                 :phonenum => params[:cellNumber],
                 :telephonenum => params[:telephone],
                 :email => params[:email],
                 :weixin => params[:weixin]
              )
         end
         
         guest = Guest.where(:name => params[:username]).first
         password=params[:password]
         logger.info params[:password]
         if guest.nil?
            Guest.create!(name:params[:username],password:params[:password],password_confirmation:params[:password],address_id:ad.id,contact_id:contact.id)
         else
            guest.update_attributes(:address_id=>ad.id,:contact_id =>contact.id)
         end
         group = Guestnode.where(:guest_id => guest.id,:access_node_id=>node.id).first
         if group.nil?
            Guestnode.create!(guest_id:guest.id,access_node_id:node.id)
         end
         node.update_attributes(:guest_id => guest.id)
       else
         guest = Guest.where(:name => params[:username]).first
         if guest
           if guest && guest.address_id
              tempad = Address.where(:id => guest.address_id).first
              ad = Address.where(:access_node_id => node.id).first
              if ad.nil?
                 Address.create!(access_node_id:node.id,city:tempad.city,detail:tempad.detail,province:tempad.province,district:tempad.district)
              else
                 ad.update_attributes(
                  :city => tempad.city,
                  :province => tempad.province,
                  :district => tempad.district,
                  :detail => tempad.detail
                 )
              end
           end
           if guest && guest.contact_id
              tempcon = Contact.where(:id => guest.contact_id).first
              contact = Contact.where(:access_node_id => node.id).first
              if contact.nil?
                Contact.create!(access_node_id:node.id,merchant:tempcon.merchant,name:tempcon.name,phonenum:tempcon.phonenum,telephonenum:tempcon.telephonenum,email:tempcon.email,weixin:tempcon.weixin,node_mac:mac)
              else
                contact.update_attributes(
                 :merchant => tempcon.merchant,
                 :name => tempcon.name,
                 :phonenum => tempcon.phonenum,
                 :telephonenum => tempcon.telephonenum,
                 :email => tempcon.email,
                 :weixin => tempcon.weixin
                )
              end
           end
           group = Guestnode.where(:guest_id => guest.id,:access_node_id=>node.id).first
           if group.nil?
              Guestnode.create!(guest_id:guest.id,access_node_id:node.id)
           end
           node.update_attributes(:guest_id => guest.id)
         else
          bok=false
          result="fail"
          message="用户不存在"
         end
       end
       respond_to do |format|
          format.html {render text: message}
          format.json {render :json => {:result=>result, :message=>message,:dev_id => dev_id }}
       end
    else
    end
  end

end
