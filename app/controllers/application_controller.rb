class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_ip_address
    `ifconfig`.match(/inet addr:(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})/)[1]
  end


end
