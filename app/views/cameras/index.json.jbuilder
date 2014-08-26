json.array!(@cameras) do |camera|
  json.extract! camera, :id, :label, :ipv4, :username, :password
  json.url camera_url(camera, format: :json)
end
