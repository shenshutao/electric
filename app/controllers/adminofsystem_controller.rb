class AdminofsystemController < ApplicationController
    def index
        if session[:current_user_id] != "adminSecrete"
            render plain:  "You haven't log in."
        end
    end

    def comparison
        if session[:current_user_id] != "adminSecrete"
            render plain:  "You haven't log in."
        end
    end

    def new
    end

    def create
        if params[:session][:email] == "admin@admin.com" && params[:session][:password] == "WeAreTheBest!"
            # Log the user in and redirect to the user's show page.
            session[:current_user_id] = "adminSecrete"
            redirect_to '/adminofsystem/index'
        else
            #flash[:danger] = 'Invalid email/password combination' # Not quite right!
            render 'new'
        end
    end
end
