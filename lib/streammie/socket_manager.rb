
#============================================================================
# ** SocketManager Class
#------------------------
#============================================================================
class Streammie::SocketManager

  SERVER_ADDR = '192.168.1.39'
  SOCKET_PORT = 20066
  
  class << self
    
    def Setup
      @socket = Socket::new( SERVER_ADDR, SOCKET_PORT )
    end
    
    def GetMessage
      @socket.gets
    end
    
  end
end
