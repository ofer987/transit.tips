json.array!(@statuses) do |status|
  json.extract! status, :id, :line, :type, :description, :tweeted_at
  json.url status_url(status, format: :json)
end
