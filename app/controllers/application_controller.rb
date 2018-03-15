class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  
  def set_locale
    I18n.locale = current_user.try(:locale) || I18n.default_locale
  end

  def current_user
    return unless session[:current_user_id]
    @current_user ||= User.where("feedId = ?", session[:current_user_id]).select("locale")[0]
  end
end
