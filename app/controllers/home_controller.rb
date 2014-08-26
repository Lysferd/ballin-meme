
class HomeController < ApplicationController
  
  def add_camera
    @camera = Camera::find_by_id( params[:camera] )
    render( 'camera', format: :js )
  end
  
  def test_message
    
    # Streammie::Send( "MASTER IS #{$$}" )
  end
  
  def get_data
    Streammie::Send( 'Status(0)' )
    sleep 0.1
    @data = Marshal::load( Streammie::RD.gets ).inspect
    render( 'data', format: :js )
  end
  
  def kill_slave
    Streammie::Send( 'Quit' )
  end
  
  def admin
  end
  
  def create
    if user = User::authenticate( params[:username], params[:password] )
      session[:user_id] = user.id
      session[:vlc] = Streammie::VLC::new
      enum = user.cameras.empty? ? Camera::all.each : Camera::find( user.cameras.split( '|' ) )
      enum.each { |c| session[:vlc].rtsp( c, user ) }
      
      redirect_to( user.is_admin ? admin_url : root_url )
    else
      redirect_to( root_url, alert: 'Invalid user or password' )
    end
  end
  
  def destroy
    session[:user_id] = nil
    
    if session[:vlc]
      session[:vlc].terminate
      session[:vlc] = nil
    end
    
    redirect_to( root_url, notice: 'Logged out' )
  end
  
  def rtsp
    respond_to do |format|
      format.html { redirect_to home_live_path }
      format.js
    end
  end
end
