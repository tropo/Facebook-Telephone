class FacebookController < ApplicationController
  def index
    
    #Testing
    # session["id"] = "1115105088"

    @user = User.find_by_facebookid(session["id"])
    
    if @user
     
      friends = RestClient.get "https://graph.facebook.com/me/friends", {:params => {:access_token => @user.token}}

      if friends.body
        data = friends.body
        @friends = JSON.parse(data)
      end
      
    end 
    
  end

  def show
  end

end
