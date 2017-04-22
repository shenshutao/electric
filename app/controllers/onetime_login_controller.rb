class OnetimeLoginController < ApplicationController
  def index
    #Rails.logger.debug("My object: #{@some_object.inspect}")
    #abort params[:whatevs].inspect
    Rails.logger.debug("Hello! debug")
    if params[:tempkey] == "0cc175b9c0f1b6a831c399e269772661"
      Rails.logger.debug("Yes")
      session[:current_user_id] = "123"
    else
      Rails.logger.debug("No")
    end
  end
  def logout
    session[:current_user_id] = "0"
  end
end
