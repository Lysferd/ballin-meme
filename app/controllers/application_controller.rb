class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :rtsp_url

  ENCODER = %w( ffmpeg x264 )[1]

  def get_ip_address
    `ifconfig`.match(/inet addr:(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})/)[1]
  end

  def public_folder
    Dir::pwd + '/public/'
  end

  def log_folder
    Dir::pwd + '/log/'
  end

  def spawn_process( user, pass, ip ) #fixme: camera object
    @vlc = "cvlc rtsp://#{user}:#{pass}@#{ip}:554/PSIA/streaming/channels/101 " +
           "--sout '#{browser.ios? ? hls_method : rtp_method}'"
           #"&> #{log_folder}vlc_#{Rails.env}.log"# & disown"
    @pid = Process::spawn( @vlc, pgroup: true, in: '/dev/null', out: '/dev/null',
                           err: '/dev/null' )
    logger.debug "[!] Spawning VLC process ID: #{@pid}..."
    #Process::detach( @pid )
  end
  
  def kill_process
    return if @pid.nil?
    Process::kill( 'INT', @pid )
    logger.debug "[!] Killing VLC process ID: #{@pid}..."
    @pid = nil
  end
  
  def rtp_method( port = 8080 ) #use random between 30000 and 40000?
    return "#rtp{ dst=#{get_ip_address}, sdp=rtsp://#{get_ip_address}:#{port}/live.sdp }"
  end
  
  def hls_method( segs = 5, vcodec = 'mp4', brate = 256, fps = 32, w = 640, h = 480 )
    return "#std{ access=livehttp{ numsegs=#{segs}," +
           "index=#{public_folder}live.m3u8," +
           "index-url=http://#{get_ip_address}/live-####.ts }," +
           "mux=ts, dst=#{public_folder}live-####.ts }"

           #":transcode{ vcodec=#{vcodec}," +
           #            "vb=#{brate}," +
           #            "venc=#{ENCODER}," +
           #            "fps=#{fps}," +
           #            "width=#{w}," +
           #            "height=#{h} }"
  end

  def rtsp_url
    return "rtsp://#{get_ip_address}:8080/live.sdp"
  end

end

