
class Raspi < ActiveRecord::Base
  
  #-------------------------------------------------------------------------
  belongs_to :user
  CONNECTION_PORT = 20000
  
  #-------------------------------------------------------------------------
  def self::all_ports
    ports = [ ]
    Raspi::all.each do |raspi|
      ports << raspi.port
    end
    return ports
  end
  
  #-------------------------------------------------------------------------
  def port( ip = self.ipv4 )
    ip =~ /(\d{1,3})$/
    return CONNECTION_PORT + $1.to_i
  end
  
  #-------------------------------------------------------------------------
  alias :old_save :save
  def save
    old_save
    connect_raspi
  end
   
  #-------------------------------------------------------------------------
  alias :old_update :update
  def update( *args )
    disconnect_raspi
    old_update( *args )
    connect_raspi
  end
  
  #-------------------------------------------------------------------------
  alias :old_destroy :destroy
  def destroy
    disconnect_raspi
    old_destroy
  end
  
  #-------------------------------------------------------------------------
  def connect_raspi
    Streammie::Send( "Connect(#{port})" )
  end
  
  #-------------------------------------------------------------------------
  def status_raspi
    Streammie::Send( "Status(#{port})" )
    sleep 0.1
    return Streammie::RD.gets
  # rescue
    # return "UNKNOWN"
  end
  alias :status :status_raspi
  
  #-------------------------------------------------------------------------
  def disconnect_raspi
    Streammie::Send( "Disconnect(#{port})" )
  end
end
