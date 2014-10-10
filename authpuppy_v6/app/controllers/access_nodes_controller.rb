#a encoding: utf-8
class AccessNodesController < ApplicationController
  before_filter :check_admin
  
  def index
    current_admin ||= Admin.find_by_token(cookies[:token]) if cookies[:token]
    if current_admin
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        @access_nodes = AccessNode.where("mac like ?","%#{mac}%").paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.paginate(page: params[:page]);
      end
    end 
    
    current_guest ||= Guest.find_by_token(cookies[:token]) if cookies[:token]
    if current_guest
      logger.info current_guest.id
      if params[:mac]
        mac = params[:mac].gsub(/[:-]/, "").upcase
        @access_nodes = AccessNode.where("mac like ? and guest_id = ?","%#{mac}%",current_guest.id).paginate(page: params[:page]);
      else
        @access_nodes = AccessNode.where(:guest_id =>current_guest.id).paginate(page: params[:page]);
      end 
    end
  end
  
  def searchbymac
     @access_nodes = AccessNode.where("mac like %?",params[:mac]).paginate(page: params[:page]);
     redirect_to :action => "index" ,:mac =>params[:mac]
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
    @access.update_attributes(:nodecmd_id=>params[:nodecmd_id],:cmdflag =>true )
    flash[:notice] = "远程操作成功！"
    redirect_to access_nodes_url;
  end
  def register
  end
  
end
