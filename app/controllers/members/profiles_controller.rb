class Members::ProfilesController < ApplicationController
  before_filter :load_member, :except => [:index, :publishers, :by_tag, :my_profile, :autocomplete]
  before_filter :load_tags, :only => [:index, :publishers, :by_tag]
  before_filter :load_open_graph_meta, :only => [:show, :reports, :following, :followed_by]
  caches_action :index, :publishers, :by_tag, :autocomplete, 
    :cache_path => Proc.new {|controller| controller.params}, 
    :expires_in => 1.hour

  def index
    @members = Member.listable.paginate(:page => params[:page], :per_page => 30)
    render :action => 'index'
  end
  
  def publishers
    @members = Member.listable.publishers.paginate(:page => params[:page], :per_page => 30)
    render :action => 'index'
  end

  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @members = Member.tagged_with(@tag).listable.paginate(:page => params[:page], :per_page => 30)
    render :action => 'index'
  end

  def show
    @statuses = @member.statuses.page(params[:page])
    render :layout => 'one_column'
  end

  def surveys
    @surveys = Survey.live.owned_or_collaborating(@member.id).page(params[:page])
    render :layout => 'one_column'
  end

  def reports
    @reports = Report.owned_or_collaborating(@member.id).page(params[:page])
    render :layout => 'one_column'
  end

  def following
    @follows = @member.follows.page(params[:page])
    render :layout => 'one_column'
  end

  def followed_by
    @followings = @member.member_followers.page(params[:page])
    render :layout => 'one_column'
  end

  def my_profile
    if member_signed_in?
      redirect_to member_path(current_member)
    else
      authenticate_member!
    end
  end
  
  def autocomplete
    @members = Member.listable.where('nickname ilike ?', "#{params[:term]}%").limit(20)
  end

  protected

    def load_member
      @member = @followable = Member.find(params[:id])
      if @member.privacy_dont_list_me? and request.path != member_path(@member)
        redirect_to member_path(@member)
        false
      end
    rescue 
      error_404
    end

    def load_tags
      @tags = Member.listable.tag_counts :start_at => 2.months.ago, :limit => 100
      if @tags.empty?
        @tags = Member.listable.tag_counts :limit => 100
      end
    end

    def load_open_graph_meta
      @open_graph_meta = {
        :url => member_url(@member),
        :title => @member.nickname,
        :description => @member.tags.join(', '),
        :image_url => avatar_url(@member),
        :type => 'Member'
      }
    end
end
