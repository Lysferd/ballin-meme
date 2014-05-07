class HomeController < ApplicationController
  PUBLIC_FOLDER = Dir::pwd + "/public/"
  ENCODER = %w( ffmpeg x264 )[1]
  
  def index
    # camera attribute definition
    # from databases!
    ip = '192.160.1.33'
    user = 'developer'
    pass = 'dev@123'

    @vlc_command = "vlc -I dummy rtsp://#{ip}:554/PSIA/streaming/channels/101 vlc://quit --rtsp-user '#{user}' --rtsp-pwd '#{pass}' --sout '#{browser.ios? ? hls_method : rtp_method}'"

    @process_id = spawn( @vlc_command )
    Process.wait( @process_id )
    #Process.detach( @process_id )
  end
  
  def rtp_method(outport = 554)
    "#rtp{ dst=#{get_ip_address}, sdp=rtsp://#{get_ip_address}:#{outport}/live.sdp }"
  end
  
  def hls_method(segmentations = 5, video_codec = 'mp4', bitrate = 256, fps = 32, width = 640, height = 480 )
    "#std{ access=livehttp{ numsegs=#{segmentations}, index=#{PUBLIC_FOLDER}live.m3u8, index-url=http://#{get_ip_address}:3000/live-####.ts }, mux=ts, dst=#{PUBLIC_FOLDER}live-####.ts }"
#:transcode{ vcodec=#{video_codec}, vb=#{bitrate}, venc=#{ENCODER}, fps=#{fps}, width=#{width}, height=#{height} }"
  end
end
