json.array!(@users) do |user|
  json.extract! user, :id, :username, :hashed_password, :salt, :cameras, :is_admin
  json.url user_url(user, format: :json)
end
