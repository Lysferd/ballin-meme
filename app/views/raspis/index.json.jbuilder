json.array!(@raspis) do |raspi|
  json.extract! raspi, :id, :label, :ipv4, :user_id
  json.url raspi_url(raspi, format: :json)
end
