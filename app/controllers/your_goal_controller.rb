class YourGoalController < ApplicationController
    def index
        if session[:current_user_id] != "123"
            render :text => "You haven't log in."
        end
    end
end
