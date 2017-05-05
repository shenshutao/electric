class OnetimeLoginController < ApplicationController
  def index
    # Login with a passwordKey in the URL
    user = User.where("passwordKey = ?", params[:tempkey])
    if user.length >= 1
      # Successfully logged in.
      session[:current_user_id] = user[0]['feedId']
      session[:user_group] = user[0]['groupNum']
      redirect_to '/welcome/index'
    else
      render :text=>"Incorrect addresss. To login your account, please use the correct address assigned to you. Thanks."
    end
  end
  def logout
    session[:current_user_id] = "0"
  end
end
