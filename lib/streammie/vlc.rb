
require( 'socket' )
require( 'posix/spawn' )

#============================================================================
# ** Streammie::VLC Class
#-------------------------
#  This instance of `Class' class mixes all functionality from POSIX::Spawn
# gem in order to spawn, manage and terminate VLC processes.
#============================================================================
class Streammie::VLC
  include( POSIX::Spawn ) # mixin with posix/spawn
  
  attr_reader :instances
  
  IP_ADDRESS    = Socket::ip_address_list[1].ip_address             # eth0 ip address
  PUBLIC_FOLDER = '%s/public' % Dir::pwd
  LOG_FOLDER    = '%s/log' % Dir::pwd
  TMP_FOLDER    = '%s/tmp' % Dir::pwd
  RTSP_URL      = 'rtsp://%s:%s@%s:554/PSIA/streaming/channels/101' # camera rtsp url
  WAIT_TIME     = 0.1                                               # define wait time in seconds for synching
  PORT_RANGE    = 2000..5000
  
  #-------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  def initialize
    @instances = Hash::new
  end
  
  #-------------------------------------------------------------------------
  def []( index )
    return @instances[index]
  end
  
  #-------------------------------------------------------------------------
  # * Process Spawning
  #-------------------------------------------------------------------------
  def summon( user, pass, ipv4, id, url )
    vlc = "cvlc #{RTSP_URL % [user, pass, ipv4]} --sout '#{url}' & echo $!>#{TMP_FOLDER}/pid"
    sh  = spawn( vlc, in: '/dev/null', out: '/dev/null', err: "#{LOG_FOLDER}/camera#{id}.log" )
    
    sleep( WAIT_TIME )
    Process::detach( sh )
    
    @instances[id][:pid] = `cat #{TMP_FOLDER}/pid`.to_i
    
    return @instances[id]
  end
  
  #-------------------------------------------------------------------------
  # * Real Time Stream Protocol Initialization
  #-------------------------------------------------------------------------
  def rtsp( camera, user )
    id = camera.get_id
    return if @instances[id]
    addr = "rtsp://%s:%d/live%s.sdp" % [ IP_ADDRESS, generate_port, generate_salt ]
    @instances[id] = Hash[ pid: nil, address: addr ]
    summon( camera.username, camera.password, camera.ipv4, id, "#rtp{ dst=#{IP_ADDRESS}, port=1234, sdp=#{addr} }" )
  end
  
  #-------------------------------------------------------------------------
  # * VLC Process Termination
  #-------------------------------------------------------------------------
  def terminate( pid = 0 )
    return if @instances.empty?

    # Terminating a single process
    unless pid.zero?
      fail IndexError unless @instances.any? { |i| i[1].values.include? pid }
      Process::kill( 15, pid ) rescue nil
      sleep( WAIT_TIME )
      @instances.delete( @instances.find { |i| i[1].key( pid ) }[0] )
      
    # Terminating all processes
    else
      @instances.collect { |i| Process::kill( 15, i[1][:pid] ) rescue next }
      sleep( WAIT_TIME ) # wait for processes to safely terminate
      @instances.clear
    end
  end
  
  #-------------------------------------------------------------------------
  # * Generate Port Method
  # Generates a random number using PORT_RANGE array as boundaries.
  #-------------------------------------------------------------------------
  def generate_port
    begin
      port = rand( PORT_RANGE )
    end until `lsof -i :#{port}`.empty?
    return port
  end
  
  #-------------------------------------------------------------------------
  # * Generate URI Salt
  # Generates a random succession of numbers to individualize each RTSP
  # URI.
  #-------------------------------------------------------------------------
  def generate_salt
    return self.object_id.to_s + rand.to_s.delete( '0.' )
  end
end


__END__

#cvlc -vvv rtsp://developer:dev123@192.168.1.33:554/PSIA/streaming/channels/101 --sout "#duplicate{dst=rtp{ dst=192.168.1.39, port=1001, sdp=rtsp://192.168.1.39:8081/live1.sdp }}" &
#-------------------------------------------------------------------------
# * HTTP Live Stream Initialization
# disabled
#-------------------------------------------------------------------------
def hls( user, pass, ipv4, id = nil )
id = get_id( ipv4 ) unless id
summon( user, pass, ipv4, id, "#duplicate{dst=std{ access=livehttp{ seglen=5,numsegs=5," +
"index=#{PUBLIC_FOLDER}/live#{id}.m3u8," +
"index-url=http://#{IP_ADDRESS}/live#{id}-####.ts }," +
"mux=ts{use-key-frames}, dst=#{PUBLIC_FOLDER}/live#{id}-####.ts }}" )
end

#-------------------------------------------------------------------------
# * HTTP Live Stream Files Disposing
# disabled
#-------------------------------------------------------------------------
def remove_hls_files( id = nil )
Dir::glob( "#{PUBLIC_FOLDER}/live#{id}*" ).each { |f| File::delete( f ) }
end