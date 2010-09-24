class FacebookController < ApplicationController
  def index
    
    @user = User.find_by_token(session["usertoken"])
    
  end

  def show
  end

end
