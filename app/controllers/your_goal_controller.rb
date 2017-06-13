class YourGoalController < ApplicationController
    def index
        if session[:current_user_id].nil?
            render :text => "You haven't log in."
        end
    end
end
