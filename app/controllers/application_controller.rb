class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def not_authenticated
      redirect_to login_path, alert: "Необходима регистрация"
    end

    def set_locale
      locale = #if current_user
               #  current_user.settings.locale
               if params[:locale]
                 session[:locale] = params[:locale]
               elsif session[:locale]
                 session[:locale]
              else
                http_accept_language.compatible_language_from(I18n.available_locales)
              end
      if locale && I18n.available_locales.include?(locale.to_sym)
        session[:locale] = I18n.locale = locale.to_sym
      end
    end
end
