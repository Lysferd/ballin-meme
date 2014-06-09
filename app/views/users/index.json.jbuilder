json.array!(@users) do |user|
  json.extract! user, :id, :username, :hashed_password, :salt, :camera_whitelist, :is_admin
  json.url user_url(user, format: :json)
end
