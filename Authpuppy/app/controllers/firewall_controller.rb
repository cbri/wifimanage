# encoding: utf-8
class FirewallController < ApplicationController
  before_filter :check_admin

  def tmac_add
    if params[:id].nil? and params[:mac].nil?
      redirect_to "/404"
      return;
    end

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end

    if @access.trusted_macs.count >= 5
      @err = "MAC地址白名单已满"
    else
      begin
        @mac = TrustedMac.create!(mac:params[:mac],access_node_id:params[:id]);
      rescue Exception => e
        @err = "添加失败,请检查MAC地址格式"
      end
    end
    
    if !@err.nil?
      respond_to do |format|  
        format.html { render :text=>"Success to create mac address" }
        format.js { render :action=>"addfail", :layout=>false }
      end
    else
      @access.update_attributes( :configflag => true );
      @access.clean_all_conn 
      respond_to do |format|  
        format.html { render :text=>"Success to create mac address" }
        format.js { render :layout=>false }
      end
    end
  end
  
  def back_json(code,msg)
      respond_to do |format|
         format.json {render :json => {:status => {:code=>code.to_s, :message=>msg }}}
      end
  end

  def add_mac_white
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return        
      end
      if params[:mac].nil?
         back_json(400101,"Parameter:mac is missing")
         return        
      end
      if !(params[:mac]=~/^[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}$/)
         back_json(400101,"mac is error")
         return
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      tmac=TrustedMac.find(:first, :conditions => ["mac = ? and access_node_id = ?", params[:mac],node.id])
      if tmac
         back_json(400101,"mac is existing in whitelists")
         return
      end
      TrustedMac.create!(mac:params[:mac],access_node_id:node.id)
      back_json(200,"Success to add mac address")
      
  end

  def del_mac_white
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return        
      end
      if params[:mac].nil?
         back_json(400101,"Parameter:mac is missing")
         return        
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      tmac=TrustedMac.find(:first, :conditions => ["mac = ? and access_node_id = ?", params[:mac],node.id])
      if tmac.nil?
         back_json(400101,"mac is not existing in whitelists")
         return
      end
      tmac.delete
      back_json(200,"Success to del mac address")
      
  end

  def tmac_del
    if params[:id].nil?
      redirect_to "/404"
      return;
    end

    TrustedMac.find(params[:id]).delete
    @mac = params[:id]
    respond_to do |format|  
      format.html { render :text=>"Fail to create mac address" }
      format.js { render :layout=>false }
    end
  end

  def bmac_add
    if params[:id].nil? and params[:mac].nil?
      redirect_to "/404"
      return;
    end

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end

    if @access.black_macs.count >= 5
      @err = "MAC地址黑名单已满"
    else
      begin
        @mac = BlackMac.create!(mac:params[:mac],access_node_id:params[:id]);
      rescue Exception => e
        @err = "添加失败,请检查MAC地址格式"
      end
    end

    if !@err.nil?
      respond_to do |format|  
        format.html { render :text=>"Success to create mac address" }
        format.js { render :action=>"addbfail", :layout=>false }
      end
   else 
     respond_to do |format|  
       format.html { render :text=>"Success to create mac address" }
       format.js { render :layout=>false }
     end
    end
  end

  def add_mac_black
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return        
      end
      if params[:mac].nil?
         back_json(400101,"Parameter:mac is missing")
         return        
      end
      if !(params[:mac]=~/^[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}:[0-9a-z]{2}$/)
         back_json(400101,"mac is error")
         return
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      bmac=BlackMac.find(:first, :conditions => ["mac = ? and access_node_id = ?", params[:mac],node.id])
      if bmac
         back_json(400101,"mac is existing in blacklists")
         return
      end
      BlackMac.create!(mac:params[:mac],access_node_id:node.id)
      back_json(200,"Success to add blacklist")
      
  end

  def del_mac_black
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return        
      end
      if params[:mac].nil?
         back_json(400101,"Parameter:mac is missing")
         return        
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      bmac=BlackMac.find(:first, :conditions => ["mac = ? and access_node_id = ?", params[:mac],node.id])
      if bmac.nil?
         back_json(400101,"mac is not existing in blacklists")
         return
      end
      bmac.delete
      back_json(200,"Success to del blacklist ")
      
  end

  def add_ip_white
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return
      end
      if params[:ip].nil?
         back_json(400101,"Parameter:ip is missing")
         return
      end
      if !(params[:ip]=~/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)
         back_json(400101,"ip is error")
         return
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      bip=PublicIp.find(:first, :conditions => ["publicip = ? and access_node_id = ?", params[:ip],node.id])
      if bip
         back_json(400101,"ip is  existing in whitelists")
         return
      end
      PublicIp.create!(publicip:params[:ip],access_node_id:node.id)
      back_json(200,"Success to add whitelist")

  end

  def del_ip_white
      if params[:gw_id].nil?
         back_json(400101,"Parameter:gw_id is missing")
         return
      end
      if params[:ip].nil?
         back_json(400101,"Parameter:ip is missing")
         return
      end
      node = AccessNode.find_by_mac(params[:gw_id])
      if node.nil?
         back_json(400101,"AP is not existing")
         return
      end
      wip=PublicIp.find(:first, :conditions => ["publicip = ? and access_node_id = ?", params[:ip],node.id])
      if wip.nil?
         back_json(400101,"ip is not existing in whitelists")
         return
      end
      wip.delete
      back_json(200,"Success to del whitelist ")

  end

  def ip_add
    if params[:id].nil? and params[:ip].nil?
      redirect_to "/404"
      return;
    end

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end

    if @access.public_ips.count >= 5
      @err = "IP地址白名单已满"
    else
      begin
        @ip = PublicIp.create!(publicip:params[:ip],access_node_id:params[:id]);
      rescue Exception => e
        @err = "添加失败,请检查IP地址格式"
      end
    end

    if !@err.nil?
      respond_to do |format|  
        format.html { render :text=>"Success to create mac address" }
        format.js { render :action=>"addipfail", :layout=>false }
      end
   else 
     @access.update_attributes( :configflag => true );
     @access.clean_all_conn 
     respond_to do |format|  
       format.html { render :text=>"Success to create mac address" }
       format.js { render :layout=>false }
     end
    end
  end

  def bmac_del
    if params[:id].nil?
      redirect_to "/404"
      return;
    end

    BlackMac.find(params[:id]).delete
    @mac = params[:id]
    respond_to do |format|  
      format.html { render :text=>"Fail to create mac address" }
      format.js { render :layout=>false }
    end
  end

  def ip_del
    if params[:id].nil?
      redirect_to "/404"
      return;
    end

    PublicIp.find(params[:id]).delete
    @ip = params[:id]
    respond_to do |format|  
      format.html { render :text=>"Fail to create mac address" }
      format.js { render :layout=>false }
    end
  end

end
