class HomeController < ApplicationController
  
  def add_camera
    @camera = Camera::find_by_id( params[:camera] )
    render( 'camera', format: :js )
  end
  
  def create
    if user = User::authenticate( params[:username], params[:password] )
      session[:user_id] = user.id
      session[:vlc] = Streammie::VLC::new
      
      # if browser.ios?
      # if true
        # enum = user.cameras.empty? ? Camera::all.each : user.cameras.split( '|' ).each
        # enum.each { |c| session[:vlc].rtsp( c.username, c.password, c.ipv4 ) }
        # session[:vlc].rtsp( @camera.username, @camera.password, @camera.ipv4 ) unless browser.ios?
      # end
      
      redirect_to( user.is_admin ? admin_url : root_url )
    else
      redirect_to( root_url, alert: 'Invalid user or password' )
    end
  end
  
  def destroy
    session[:user_id] = nil
    session[:vlc].terminate rescue nil
    session[:vlc] = nil
    
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
