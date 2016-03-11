json.array!(@cooperations) do |cooperation|
  json.extract! cooperation, :id, :user_id, :modification_id, :ratio
  json.url cooperation_url(cooperation, format: :json)
end
