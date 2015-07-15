#a encoding: utf-8
class AccessNodesController < ApplicationController
  before_filter :check_admin
  
  def index
    current_admin ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    current_guest ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    if current_guest and current_guest.name=="admin"
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        name= params[:name]
        @access_nodes = AccessNode.where("mac like ? and name like ?","%#{mac}%","%#{name}%").paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.paginate(page: params[:page]);
      end
    end 
    
    if current_guest and current_guest.name!="admin"
      logger.info current_guest.id
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        name= params[:name]
        @access_nodes = AccessNode.where("mac like ? and name like ? and guest_id = ?","%#{mac}%","%#{name}%",current_guest.id).paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.where(:guest_id =>current_guest.id).paginate(page: params[:page]);
      end 
    end
  end
  
  def searchbymac
     @access_nodes = AccessNode.where("mac like %? and name like %?",params[:mac], params[:name]).paginate(page: params[:page]);
     redirect_to :action => "index" ,:mac =>params[:mac],:name=>params[:name]
     #redirect_to :action => "index" ,:mac =>params[:mac]
  end
  
  def saveTemplate
    if params[:macs].nil?
      respond_to do |format|
        format.html { render :text=>"Success Set Long and Lat" }
        format.json {render :json => {:code=>"300",:message=>"mac is empty"}}
      end
    end
    macs = params[:macs].split(':')
    macs.each do |mac|
        node =  AccessNode.find_by_mac(mac)
        if params[:redirect] and params[:redirect] !=''
          node.update_attributes!(:redirect_url =>params[:redirect] )
        end
        if params[:portal] and params[:portal]!=''
          node.update_attributes!(:portal_url =>params[:portal] )
        end
        if params[:duration] and params[:duration]!=''
          node.update_attributes!(:time_limit =>params[:duration].to_i )
        end
        if params[:auth_plattype] and params[:auth_plattype]!=''
          node.update_attributes!(:auth_plattype =>params[:auth_plattype].to_i )
        end
    end
    respond_to do |format|
        format.html { render :text=>"Success Set Long and Lat" }
        format.json {render :json => {:code=>"200" }}
    end
  end
  
  def new
    @access_node = AccessNode.new
  end

  def destroy
    @access_node = AccessNode.find(params[:id])
    if @access_node.destroy
      flash[:notice] = "Node Destroyed"
    else
      flash[:error] = "Error Destroy"
    end
    redirect_to :action=>"index"
  end

  def edit
    @access = AccessNode.find(params[:id])
    @auth =@access.auth ||= Auth.first
  end

  def template
    current_admin ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    current_guest ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    if current_guest and current_guest.name=="admin"
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        name= params[:name]
        @access_nodes = AccessNode.where("mac like ? and name like ?","%#{mac}%","%#{name}%").paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.paginate(page: params[:page]);
      end
    end 
    
    if current_guest and current_guest.name!="admin"
      logger.info current_guest.id
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        name= params[:name]
        @access_nodes = AccessNode.where("mac like ? and name like ? and guest_id = ?","%#{mac}%","%#{name}%",current_guest.id).paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.where(:guest_id =>current_guest.id).paginate(page: params[:page]);
      end 
    end
  end
  
  def upgrade
    if params[:id].nil? or params[:url].nil?
      redirect_to "/404"
      return;
    end

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end

    if @access.dev_id
       Task.create!(dev_id:@access.dev_id,task_code:"3000",status:"0",task_params:params[:url])
    end
    @access.update_attributes(:task_code=>"3000", :task_params=>params[:url],:cmdflag =>true )
    flash[:notice] = "正在升级设备"
    respond_to do |format|
        format.html { render :text=>"Success Set Long and Lat" }
        format.js { render :layout=>false }
    end
  end
  
  def modifyssid
    if params[:id].nil? or params[:ssid].nil?
      redirect_to "/404"
      return;
    end

    @access = AccessNode.find(params[:id])
    if @access.nil?
      redirect_to "/404"
      return;
    end
  
    if @access.dev_id
        Task.create!(dev_id:@access.dev_id,task_code:"2003",status:"0",task_params:params[:ssid])
    end
    @access.update_attributes(:task_code=>"2003", :task_params=>params[:ssid],:cmdflag =>true )
    flash[:notice] = "ssid"
    respond_to do |format|
        format.html { render :text=>"Success Set Long and Lat" }
        format.js { render :layout=>false }
    end
  end

  def query_lat_long
    if params[:id].nil? 
      flash[:notice] = "调用方式有误"
      redirect_to :action => "index" 
      return;
    end

    @access = AccessNode.find_by_id(params[:id]);

    if params[:place].nil? and params[:place].blank?
      flash[:notice] = "请输入有效的地址"
      redirect_to advance_url(@access) 
      return;
    end

    require"open-uri"
    require"json"
    uri = "http://api.map.baidu.com/geocoder/v2/?address="+params[:place].to_s+"&output=json&ak=5dfe24c4762c0370324d273bc231f45a"
    begin
      encoded_uri = URI::encode(uri)
      baidu_response = open(encoded_uri).read
      json =  ActiveSupport::JSON.decode(baidu_response)
    rescue Exception => e
      flash[:notice] = "请输入有效的地址"
      redirect_to advance_url(@access) 
      return;
    end

    if json["status"] == 0
      lng = json["result"]["location"]["lng"]
      lat = json["result"]["location"]["lat"]

      @access.update_attributes(lat:lat,long:lng)
      flash[:notice] = "改动成功"

      respond_to do |format|  
        format.html { render :text=>"Success Set Long and Lat" }
        format.js { render :layout=>false }
      end

    else
      flash[:notice] = "请输入有效的地址"
      redirect_to advance_url(@access) 
    end
  end

  def advanced
    @access = AccessNode.find(params[:id])
    @auth =@access.auth ||= Auth.first
  end

  def init
    @access = AccessNode.find(params[:id])
    @config =@access.conf ||= Conf.first
  end

  def firewall
    @access = AccessNode.find(params[:id])
    @macs = @access.trusted_macs
    @blackmac = @access.black_macs
    @publicips = @access.public_ips
    @blackips = @access.black_ips
  end



  def create
    @access_node = AccessNode.new(params[:access_node])
    if @access_node.save
      flash[:notice] = "AccessNode was successfully create"
      redirect_to :ation => "index"
    else
      flash[:notice] = "AccessNode was not successfully create"
      render :action => "new"
    end
  end

  def update
    @access_node = AccessNode.find(params[:id]);
    if @access_node.update_attributes(params[:access_node])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def show
    page = params[:page] || 1
    timeframe = params[:time] || Time.now - 1.month
    @access = AccessNode.find(params[:id])
    @connections = @access.connections.list_by_date(page, timeframe, @access_node)
    @online_num = @access.show_online()
    @daily_num = @connections.unique_by_date(Time.now.to_date).length
  end

  def setconfig
    @access = AccessNode.find(params[:id])
    nodecmd =Nodecmd.find(params[:nodecmd_id])
    taskcode=0
    if nodecmd
       if nodecmd.task_code
         taskcode=nodecmd.task_code
       end
    end   
    if @access.dev_id
      Task.create!(dev_id:@access.dev_id,task_code:taskcode,status:"0")
    end
    @access.update_attributes(:nodecmd_id=>params[:nodecmd_id],:task_code =>taskcode,:cmdflag =>true )
    flash[:notice] = "远程操作成功！"
    redirect_to access_nodes_url;
  end
  def register
  end
  
end
