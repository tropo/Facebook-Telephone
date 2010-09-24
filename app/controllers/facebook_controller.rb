class FacebookController < ApplicationController
  def index
    
    @user = User.find_by_facebookid(session["id"])
    
  end

  def show
  end

end
