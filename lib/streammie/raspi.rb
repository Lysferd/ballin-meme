
#============================================================================
# ** Raspberry Pi Container
#---------------------------
#  This instance of `Class' class acts as a virtual container for all the
# Raspberry Pi computers available on the network.
# FIXME: this class is to be replaced for a RoR model
#============================================================================
class RasPi
  PORT = 20000
  attr_reader :ipv4
  
  def initialize( ip = '172.16.0.6' )
    @ipv4 = ip
  end
  
  def port
    return PORT + /(\d{1,3})$/.match( @ipv4 )[0].to_i
  end
end
