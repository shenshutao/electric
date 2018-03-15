class WelcomeController < ApplicationController
  def index
    if session[:current_user_id].nil?
        #render plain:  "You haven't log in."
        redirect_to '/welcome/firstpage'
    end
    @usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)").last(7);
  end

  def profile
    if session[:current_user_id].nil?
        render plain:  "You haven't log in."
    end
    @user = User.where("feedId = ?", session[:current_user_id]).limit(1);
  end

  def setting
    if session[:current_user_id].nil?
      render plain:  "You haven't log in."
    end
    user = User.find_by(feedId: session[:current_user_id]);
    if params['setLang'] != nil
      puts params['setLang']
      if params['setLang'] == "what"
        # render is equvalent to return.
        render plain: user.to_json
        return
      end
      user.locale = params['setLang']
      I18n.locale = params['setLang']
      user.save
      render plain: user.to_json
    end
  end

  def powerdetail
    if session[:current_user_id].nil?
        render plain:  "You haven't log in."
    end
  end

  def firstpage
    
  end
end
