class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :start_date, :stop_date

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :start_date
  before_action :stop_date

  def start_date
    if params[:start_date]
      session[:start_date] = params[:start_date]
    else
      session[:start_date] = ENV['START_DATE']
    end
  end

  def stop_date
    if params[:stop_date]
      session[:stop_date] = params[:stop_date]
    elsif session[:stop_date]
      session[:stop_date]
    else
      session[:stop_date] = ENV['STOP_DATE']
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
