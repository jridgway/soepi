class Members::TokensController < ApplicationController
  prepend_before_filter :authenticate_member!

  def index
    @member_tokens = current_member.tokens
  end

  def destroy
    current_member.tokens.destroy(params[:id])
    redirect_to :action => 'index'
  end
end
