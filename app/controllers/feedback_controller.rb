class FeedbackController < ApplicationController
  def index
    if session[:current_user_id] == "0"
        render :text => "You haven't log in."
    end
  end
end
