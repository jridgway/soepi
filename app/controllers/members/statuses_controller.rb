class Members::StatusesController < ApplicationController
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_facebook_meta, :only => [:show, :code, :output, :edit, :update]
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'two_column' }  
  def index 
    @statuses = MemberStatus.page(params[:page]).per(10)
  end 
  
  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @statuses = MemberStatus.tagged_with(@tag).page(params[:page])
    render :action => 'index'
  end
  
  protected   

    def load_tags
      @tags = MemberStatus.tag_counts :start_at => 2.months.ago, :limit => 100
    end

    def load_facebook_meta
      @member_status = MemberStatus.find params[:id] 
      @facebook_meta = {
        :url => member_status_url(@member_status),
        :title => @member_status.member.nickname,
        :description => @member_status.body,
        :image_url => "#{request.protocol}#{request.host_with_port}/assets/soepi-logo-light-bg.png",
        :type => 'MemberStatus'
      }
    end
end
