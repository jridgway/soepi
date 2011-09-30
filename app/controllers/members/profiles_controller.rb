class Members::ProfilesController < ApplicationController
  before_filter :load_member, :except => [:index, :my_profile, :by_tag, :autocomplete]
  before_filter :load_tags, :only => [:index, :by_tag]
  before_filter :load_facebook_meta, :only => [:show, :following, :followed_by]

  def index
    @members = Member.listable.page(params[:page]).per(30)
  end

  def by_tag
    @tag = ActsAsTaggableOn::Tag.find params[:tag]
    @members = Member.tagged_with(@tag).listable.page(params[:page]).per(30)
    render :action => 'index'
  end

  def show
    @surveys = @member.surveys_posted.live.page(params[:page])
    render :layout => 'one_column'
  end

  def following
    @follows = @member.follows.page(params[:page]).per(10)
    render :layout => 'one_column'
  end

  def followed_by
    @followings = @member.member_followers.page(params[:page]).per(10)
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
    set_cache_control
    @members = Member.listable
  end

  protected

    def load_member
      @member = Member.find(params[:id])
    end

    def load_tags
      @tags = Member.listable.tag_counts :start_at => 2.months.ago, :limit => 100
    end

    def load_facebook_meta
      @facebook_meta = {
        :url => member_url(@member),
        :title => @member.nickname,
        :description => @member.location,
        :image_url => avatar_url(@member),
        :type => 'Member'
      }
    end
end
