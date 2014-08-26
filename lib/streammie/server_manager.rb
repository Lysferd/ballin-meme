
#============================================================================
# ** ServerManager Class
#------------------------
# !TCPSocket#gets returns nil when connection is closed
# !TCPSocket#new returns Errno::ECONNREFUSED when server is not started
#============================================================================
class ServerManager
  
  class << self
    
    attr_reader :servers
    
    #---------------------------------------------------------------------
    # * Setup Socket Servers
    #---------------------------------------------------------------------
    def Setup( ports )
      log 'Server Manager Initialization!'
      
      @servers = Hash::new
      ports.each { |port| Connect( port ) }
      return true
    end
    
    #---------------------------------------------------------------------
    # * Estabilish Socket Connection
    #---------------------------------------------------------------------
    def Connect( *ports )
      fail ArgumentError if ports.empty?
      for port in ports
        if @servers.has_key?( port )
          log "WARNING: Connection already existed to that port #{port}."
          Terminate( port )
        end
        
        log "Estabilishing connection with server on port #{port}..."
        @servers[port] = Server::new( port )
        log "Connection estabilished on port #{port}."
      end
      
      return true
    end
    
    #---------------------------------------------------------------------
    # * Sending Messages
    # port = 0 for broadcast
    #---------------------------------------------------------------------
    def []=( port, message )
      log " Sending message to #{port}: #{message}"
      @servers[port].puts( message ) if @servers[port].status == 'ESTABILISHED'
    rescue
      log '[ERROR!] ' + $!.message
      return 'INTERNAL ERROR: ' + $!.message
    end
    
    #---------------------------------------------------------------------
    # * Acquire Server Status
    #-------------------------
    #  This instance of `Method' class checks every server and returns
    # its current status of operation.
    # 
    # TCPServer#puts raises Errno::EPIPE when connection is closed
    # TCPServer#accept waits until connection happens
    #---------------------------------------------------------------------
    def Status( port = 0 )
      unless port.zero?
        log "Fetching status of server on port #{port}..."
        status = @servers[port].status
        log "Server status is #{status}."
        return status
      else
        str = [ ]
        for port, server in @servers
          log "Fetching status of server on port #{port}..."
          str << server.status
          log "Server status is #{str[-1]}."
        end
        return str
      end
    rescue
      log '[ERROR!] ' + $!.message
      return 'INTERNAL ERROR: ' + $!.message
    end
    
    #---------------------------------------------------------------------
    # * Server Reconnecting
    #---------------------------------------------------------------------
    def Reconnect( port = 0 )
      unless port.zero?
        log "Performing reconnection to server on port #{port}..."
        @servers[port].reconnect
        log 'Reconnected successfully.'
      else
        for port, server in @servers
          log " Reconnecting server on port #{port}: "
          server.reconnect
          log 'OK'
        end
      end
    end
    
    # ---------------------------------------------------------------------
    # * Server Resetting
    # ---------------------------------------------------------------------
    def Reset( port = 0 )
      unless port.zero?
        log " Resetting server on port #{port}: "
        @servers[port].close
        @servers[port] = Server::new( port )
        log 'OK'
      else
        for port, server in @servers
          log " Resetting server on port #{port}: "
          server.close
          server = Server::new( port )
          log 'OK'
        end
      end
    end
    
    #---------------------------------------------------------------------
    # * Server Disposal
    #---------------------------------------------------------------------
    def Terminate( port = 0 )
      unless port.zero?
        log "Terminating connection on port #{port}..."
        @servers[port].close
        @servers.delete( port )
        log 'Connection termination successful.'
      else
        for port, server in @servers
          log "Terminating server on port #{port}: "
          server.close
          log 'OK'
        end
        @servers.clear
      end
    rescue
      log '[ERROR!] ' + $!.message
    end
    
    #-----------------------------------------------------------------------
    # * Logger Debug
    #-----------------------------------------------------------------------
    def log( message )
      system "echo \">>SERVERMANAGER [#{caller_locations(1,1)[0].label.upcase}] #{message}\" >> /dev/tty1"
    end
    
  end
end
