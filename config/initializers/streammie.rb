# Encoding: UTF-8

module Streammie
  VERSION = [ 0, 0, 1 ]
  RD, WR = IO::pipe
  
  def self::Send( str )
    WR.puts( str )
    WR.flush
  end
  
  def self::Dump( data )
    WR.puts( Marshal::dump( data ).encode( Encoding::UTF_8 ) )
    WR.flush
  end
  
  def self::Receive
    RD.gets
  end
  
  def self::Load
    Marshal::load( Receive )
  end
  
  begin
    # -=-=-=-
    # Initialize Slave Process
    PID = spawn( 'ruby -- ./lib/slave.rb', { in: RD, out: WR } )
    
    # -=-=-=-
    # Send to slave all RasPi objects.
    Dump( Raspi::all_ports )
  end
end

require( './lib/streammie/vlc.rb' )