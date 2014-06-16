class HomeController < ApplicationController

  def live
    @cameras = Camera::all
  end
  
  def create
    if user = User::authenticate( params[:username], params[:password] )
      session[:user_id] = user.id
      
      # spawn VLC processes
      user.cameras.each do |camera|
        @vlc.summon( 'hls', camera.username, camera.password, camera.ipv4 )
      end
      
      if user.is_admin
        redirect_to( admin_url )
      else
        redirect_to( root_url )
      end
    else
      redirect_to( root_url, alert: 'Invalid user or password' )
    end
  end

  def destroy
    session[:user_id] = nil
    
    @vlc.terminate
    
    redirect_to( root_url, notice: 'Logged out' )
  end
  
  def rtsp
    @test = 'test'
    respond_to do |format|
      format.html { redirect_to home_live_path }
      format.js
    end
  end
end
