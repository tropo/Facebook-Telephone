class AuthorizeController < ApplicationController

# http://developers.facebook.com/docs/api#authorization
# 
# Telephone Oauth login
# https://graph.facebook.com/oauth/authorize?client_id=104425026288823&redirect_uri=http://telephone.heroku.com/oauth_redirect
# 
# FB Response 1
# http://telephone.heroku.com/oauth_redirect?code=2.gtz_CSXhMbzSaWls9CyNwg__.3600.1285297200-1115105088|zrj2UMz6YyuLw07fCO8_Fudm_o4
# 
# Telephone Response 2
# https://graph.facebook.com/oauth/access_token?client_id=104425026288823&redirect_uri=http://telephone.heroku.com/oauth_redirect&client_secret=a4807180f4586dc5df989d4d03e242b1&code=2.gtz_CSXhMbzSaWls9CyNwg__.3600.1285297200-1115105088|zrj2UMz6YyuLw07fCO8_Fudm_o4
# 
# FB Response 2
# access_token=104425026288823|2.gtz_CSXhMbzSaWls9CyNwg__.3600.1285297200-1115105088|VUEJHNws20FitmBxSRrEx1EeH2U&expires=3317
# 
# Telephone current user request 
# https://graph.facebook.com/me?access_token=104425026288823|2.gtz_CSXhMbzSaWls9CyNwg__.3600.1285297200-1115105088|VUEJHNws20FitmBxSRrEx1EeH2U&expires=3317
# 
# FB Response
# {
#    "id": "1115105088",
#    "name": "Chris Matthieu",
#    "first_name": "Chris",
#    "last_name": "Matthieu",
#    "link": "http://www.facebook.com/chrismatthieu",
#    "gender": "male",
#    "email": "chris@matthieu.us",
#    "timezone": -7,
#    "locale": "en_US",
#    "verified": true,
#    "updated_time": "2010-08-22T09:03:24+0000"
# }
  
  def new
    
    oauthurl = "https://graph.facebook.com/oauth/authorize?client_id=104425026288823&redirect_uri=http://telephone.heroku.com/oauth_redirect"
    # RestClient.get oauthurl
    
    redirect_to oauthurl
        
  end
  
  def oauth_redirect
    code =   params[:code]
    oauthurl = "https://graph.facebook.com/oauth/access_token?client_id=104425026288823&redirect_uri=http://telephone.heroku.com/oauth_redirect&client_secret=a4807180f4586dc5df989d4d03e242b1&code=" + code
    resp = RestClient.get oauthurl
    
    if resp.body
      token = resp.body.gsub("access_token=", "")
      
      #Now fetch and update user data
      userurl = "https://graph.facebook.com/me?access_token=" + token
      userresp = RestClient.get userurl

      if userresp.body
        data = userresp.body
        result = JSON.parse(data)
        
        @user = User.find_by_facebookid(result["id"])
        if @user.nil?
          @user = User.new
        end

        @user.name = result["id"]
        @user.firstname = result["first_name"]
        @user.lastname = result["last_name"]
        @user.link = result["link"]
        @user.gender = result["gender"]
        @user.email = result["email"]
        @user.timezone = result["timezone"]
        @user.locale = result["locale"]
        @user.verified = result["verified"]
        @user.token = token
        @user.save
        
        session["usertoken"] = token

      end
    end

    redirect_to '/facebook'

  end

end
