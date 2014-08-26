class Camera < ActiveRecord::Base
  
  CONNECTION_PORT = 20000
  
  def get_id
    self.ipv4 =~ /(\d{1,3})$/
    return CONNECTION_PORT + $1.to_i
  end
  
end
