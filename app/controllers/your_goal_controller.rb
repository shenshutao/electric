class YourGoalController < ApplicationController
    def index
        if session[:current_user_id].nil?
            render :text => "You haven't log in."
        end
        if params[:result] == "5"
            @str = "Saved 16%! Goal achieved! Keep up your good energy-saving behaviour! With this money you could afford 1 months’ internet coverage at home. ".html_safe
        end
        if params[:result] == "4"
            @str = "Saved 17%! Goal achieved! Keep up your good energy-saving behaviour! With this money you could get in 2 fitness/yoga training classes at gym.  ".html_safe
        end
        if params[:result] == "3"
            @str = "Oops, goal not achieved ( 13% away)! Remember your goal!    With this money you could have unforgettable experience in Singapore Flyer with 3 family members.  ".html_safe
        end
        if params[:result] == "2"
            @str = "Saved 2%! Goal not achieved! Huat lah! With this money you could have unforgettable experience in Singapore Flyer with 3 family members. ".html_safe
        end
    end
end
