class Members::StatusesController < ApplicationController
  before_filter :authenticate_member_2!, :only => [:create, :destroy]
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_open_graph_meta, :only => [:show, :code, :output, :edit, :update]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'two_column' }  
  caches_action :index, :by_tag, 
    :cache_path => Proc.new {|controller| cache_expirary_key(controller.params)}, 
    :expires_in => 2.hours
  cache_sweeper :statuses_sweeper, :only => [:create, :destroy]
  
  def index 
    @statuses = MemberStatus.page(params[:page])
  end 
  
  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @statuses = MemberStatus.tagged_with(@tag).page(params[:page])
    render :action => 'index'
  end
  
  def new 
    @status = current_member.statuses.build params[:member_status]
    @status.body = params[:reply_to_members]
  end
    
  def create 
    @status = current_member.statuses.build params[:member_status]
    @status.save
  end
  
  def destroy 
    if @status = MemberStatus.find(params[:id]) and (current_member.admin? or current_member.owner?(@status))
      @status.destroy      
      unless request.xhr?
        flash[:notice] = 'Your status was deleted.'
        redirect_to root_path
      end
    else  
      if request.xhr?
        render :text => %{alert('You cannot remove another member\'s status');}
      else
        flash[:notice] = 'You cannot remove another member\'s status'
        redirect_to root_path
      end
    end
  end
  
  protected   

    def load_tags
      @tags = MemberStatus.tag_counts :start_at => 2.months.ago, :limit => 100
    end

    def load_open_graph_meta
      @member_status = MemberStatus.find params[:id] 
      @open_graph_meta = {
        :url => member_status_url(@member_status),
        :title => @member_status.member.nickname,
        :description => @member_status.body,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'MemberStatus'
      }
    end
    
    def cache_expirary_key(params)
      params.merge :cache_expirary_key => Rails.cache.read(:statuses_cache_expirary_key)
    end
end
