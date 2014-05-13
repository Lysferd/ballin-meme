class HomeController < ApplicationController
  
  def index
    #spawn_process
  end


  def spawn_process
    super 'developer', 'dev123', '192.168.1.33'
    # Cameras::find_by_id( args[:camera_id].to_i )
  end
  
  def rtsp
    @test = 'test'
    respond_to do |format|
      format.html { redirect_to home_live_path }
      format.js
    end
  end

end
