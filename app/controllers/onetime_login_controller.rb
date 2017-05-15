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

  def goal
    # Login with a passwordKey in the URL
    user = User.where("passwordKey = ?", params[:tempkey])
    if user.length >= 1
      # Successfully logged in.
      session[:current_user_id] = user[0]['feedId']
      session[:user_group] = user[0]['groupNum']
      redirect_to '/your_goal/index?result=5'
    else
      render :text=>"Incorrect addresss. To login your account, please use the correct address assigned to you. Thanks."
    end
  end

  def logout
    session[:current_user_id] = nil
  end
end
