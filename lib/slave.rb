# Encoding: UTF-8

require( './lib/streammie/raspi.rb' )
require( './lib/streammie/server_manager.rb' )
require( './lib/streammie/server.rb' )

def log( message )
  system "echo \">SLAVE #{message}\" >> /dev/tty1"
end

begin
  system "clear >> /dev/tty1"
  log "SLAVE INITIALIZATION"
  log "PROCESS ID: #{Process::pid.to_s}"
  log "READ: #{$stdin.to_i} <#{$stdin.object_id}>"
  log "WRITE: #{$stdout.to_i} <#{$stdout.object_id}>"
  
  ServerManager.Setup( Marshal::load( $stdin.gets ) )
  
  loop do
    log "WITHIN MAIN LOOP"
    
    case $stdin.gets.chomp
    when /^Status\s*\(\s*(\d+)\s*\)/i
      log "STATUS PORT #$1 COMMAND RECEIVED"
      data = ServerManager.Status( $1.to_i )
      # marshalled = Marshal::dump( data )
      $stdout.puts( data )
      $stdout.flush
      sleep 0.1
      
    when /^Connect\s*\(\s*(\d+)\s*\)/i
      log "CONNECT PORT #$1 COMMAND RECEIVED"
      ServerManager.Connect( $1.to_i )
      
    when /^Send\s*\(\s*(\d+)\s*,\s*([\d\w]+)\s*\)/i
      log "SEND #$2 TO PORT #$1 COMMAND RECEIVED"
      ServerManager[$1.to_i] = $2.to_s.chomp
      
    when /^Reconnect\s*\(\s*(\d+)\s*\)/i
      log "RECONNECT PORT #$1 COMMAND RECEIVED"
      ServerManager.Reconnect( $1.to_i )
      
    when /^Reset\s*\(\s*(\d+)\s*\)/i
      log "RESET PORT #$1 COMMAND RECEIVED"
      ServerManager.Reset( $1.to_i )
      
    when /^Disconnect\s*\(\s*(\d+)\s*\)/i
      log "DISCONNECT PORT #$1 COMMAND RECEIVED"
      ServerManager.Terminate( $1.to_i )
      
    when /^Quit/i
      log "QUIT COMMAND RECEIVED"
      break
      
    else
      log "MESSAGE WAS: #$_"
    end
  end
rescue
  log $!
ensure
  log 'SLAVE TERMINATING'
end
