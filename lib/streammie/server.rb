
require( 'socket' )

#==========================================================================
# ** Streammie::Server Class
#----------------------------
#  This instance of `Class' class inherits all socket server functionality
# from the `TCPServer' superclass, developed to connect, send messages and
# manage a single socket client.
#==========================================================================
class ServerManager::Server < TCPServer
  
  def initialize( port )
    super( port )
    @port = port
    connect
  end
  
  #-------------------------------------------------------------------------
  def connect
    Thread::new { @client = self.accept }
  end
  alias :reconnect :connect
  
  #-------------------------------------------------------------------------
  def puts( *args )
    @client.puts *args
    return true
  end
  
  #-------------------------------------------------------------------------
  def status
    return 'WAITING CONNECTION' unless @client
    return 'TERMINATED' if @client.closed?
    
    self.puts 'KEEPALIVE'
    return 'ESTABILISHED'
    
  rescue Errno::EPIPE
    return 'BROKEN PIPE'
    
  rescue Errno::ECONNRESET
    return 'CONNECTION RESET'
    
  rescue NoMethodError
    return $!
  end
  
  #-------------------------------------------------------------------------
  def close
    log "CLOSING CONNECTION TO PORT: #{@port}"
    @thread.terminate rescue nil
    @client.close unless @client.nil?
    super unless self.closed?
  end
  
  #-----------------------------------------------------------------------
  # * Logger Debug
  #-----------------------------------------------------------------------
  def log( message )
    system "echo \">>>SERVER [#{caller_locations(1,1)[0].label.upcase}] #{message}\" >> /dev/tty1"
  end
    
end
