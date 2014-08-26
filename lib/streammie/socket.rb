
require( 'socket' )

#==========================================================================
# ** Streammie::Socket Class
#----------------------------
#  This instance of `Class' class inherits all socket client functionality
# from the `TCPSocket' superclass, developed to connect and receive
# messages from a socket server.
#==========================================================================
class Streammie::SocketManager::Socket < TCPSocket
  
  def initialize( *args )
    super *args
    @vlc_instance = Streammie::VLC::new
  end
  
  def gets
    m = super
    return '' if m.include? 'KEEPALIVE'
    return eval m rescue m
  end
  
  def new_connection
    return "OKAY"
  end
  
end
