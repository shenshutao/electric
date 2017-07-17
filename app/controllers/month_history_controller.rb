class MonthHistoryController < ApplicationController
  def index
    if session[:current_user_id].nil?
        render plain:  "You haven't log in."
    end
  end
end
