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
  
  def ipb_add
    if params[:id].nil? and params[:ip].nil?
      redirect_to "/404"
      return;
    end
    ipa = params[:ip].strip

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end
    if ipa==""
      @err = "IP地址为空"
    else
      begin
        @ip = BlackIp.create!(publicip:ipa,access_node_id:params[:id]);
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
     pips = PublicIp.where(" access_node_id= ? ", params[:id] )
     task_params = "{ \"whitelist\":["
     first =1
     pips.each do |pip|
       if first == 1
         task_params += "\"#{pip.publicip}\"" 
         first=0
       else
         task_params += ","
         task_params += "\"#{pip.publicip}\"" 
         
       end
     end 
     task_params +="],"

     bips = BlackIp.where(" access_node_id= ? ", params[:id] )
     task_params += "\"blacklist\":["
     first =1
     bips.each do |pip|
       if first == 1
         task_params += "\"#{pip.publicip}\"" 
         first=0
       else
         task_params += ","
         task_params += "\"#{pip.publicip}\"" 
         
       end
     end 
     task_params +="]"
     task_params +="}"
     if @access.dev_id
         Task.create!(dev_id:@access.dev_id,task_code:"10000",status:"0",task_params:task_params)
     end
        
     @access.update_attributes(:task_code=>"10000", :task_params=>task_params,:cmdflag =>true )
     #@access.clean_all_conn 
     respond_to do |format|  
       format.html { render :text=>"Success to create mac address" }
       format.js { render :layout=>false }
     end
    end
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
    ipa = params[:ip].strip
    if @access.public_ips.count >= 20
      @err = "IP地址白名单已满"
    elsif ipa==""
      @err = "IP地址为空"
    else
      begin
        @ip = PublicIp.create!(publicip:ipa,access_node_id:params[:id]);
      rescue Exception => e
        logger.info e
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
     pips = PublicIp.where(" access_node_id= ? ", params[:id] )
     params = "{ \"whitelist\":["
     first =1
     pips.each do |pip|
       if first == 1
         params += "\"#{pip.publicip}\"" 
         first=0
       else
         params += ","
         params += "\"#{pip.publicip}\"" 
         
       end
     end 
     params +="]"
     params +="}"
        
     if @access.dev_id
         Task.create!(dev_id:@access.dev_id,task_code:"10000",status:"0",task_params:params)
     end
     @access.update_attributes(:task_code=>"10000", :task_params=>params,:cmdflag =>true )
     #@access.clean_all_conn 
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
  
  def ipb_del
    if params[:id].nil?
      redirect_to "/404"
      return;
    end

    BlackIp.find(params[:id]).delete
    @ip = params[:id]
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
