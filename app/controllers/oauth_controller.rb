class OauthController < ApplicationController
  def start
    redirect_to client.web_server.authorize_url(
      :redirect_uri => 'http://telephone.heroku.com/oauth/callback'
    )
  end

  def callback
    access_token = client.web_server.get_access_token(
      params[:code], :redirect_uri => 'http://telephone.heroku.com/oauth/callback'
    )

    user_json = access_token.get('/me')
    # in reality you would at this point store the access_token.token value as well as 
    # any user info you wanted
    # render :json => user_json
    
    if !user_json.nil? 
      
      @user = User.find_by_facebookid(user_json["id"])
      if @user.nil?
        @user = User.new
      end

      @user.facebookid = user_json["id"]
      @user.name = user_json["name"]
      @user.firstname = user_json["first_name"]
      @user.lastname = user_json["last_name"]
      @user.link = user_json["link"]
      @user.gender = user_json["gender"]
      @user.email = user_json["email"]
      @user.timezone = user_json["timezone"]
      @user.local = user_json["locale"]
      @user.verified = user_json["verified"]
      @user.token = access_token.token
      @user.save
      
      session["id"] = user_json["id"]
      session["usertoken"] = access_token.token

    end
    
    redirect_to '/facebook'
    
  end

  protected

  def client
    @client ||= OAuth2::Client.new(
      '104425026288823', 'a4807180f4586dc5df989d4d03e242b1', :site => 'https://graph.facebook.com'
    )
  end
end
