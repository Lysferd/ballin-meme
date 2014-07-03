module HomeHelper
  
  def local_ip
    return Socket::ip_address_list[1].ip_address
  end
  
  def camera_index( ipv4 )
    ipv4 =~ /(\d{1,3})$/
    return $1.to_i
  end
  
end
