class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User::authenticate( params[:username], params[:password] )
      session[:user_id] = user.id
      redirect_to( admin_url )
    else
      redirect_to( live_url, alert: 'Invalid user or password\n' + params[:username] "/" + params[:password] )
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to( live_url, notice: 'Logged out' )
  end
end
