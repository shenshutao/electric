class WelcomeController < ApplicationController
  def index
    if session[:current_user_id] == "0"
        render :text => "You haven't log in."
    end
    @usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)").last(7);
  end

  def profile
    @user = User.where("feedId = ?", session[:current_user_id]).limit(1);
    puts @user[0].feedId
  end
end
