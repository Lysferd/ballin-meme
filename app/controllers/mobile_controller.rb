class MobileController < ApplicationController
  
  skip_before_filter :redirect_mobile
  
  def index
    render :layout => 'mobile'
  end

  def login
  end
end
