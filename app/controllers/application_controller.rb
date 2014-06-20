class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :redirect_mobile, except: :mobile
  
  private
  def redirect_mobile
    redirect_to mobile_url if browser.mobile?
  end
  
end

