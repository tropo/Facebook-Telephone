class ApplicationController < ActionController::Base
  # protect_from_forgery
  
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE  
  
  def isNumeric(s)
      Float(s) != nil rescue false
  end
    
end
