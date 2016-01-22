json.array!(@records) do |record|
  json.extract! record, :id, :sender, :time, :keyword, :text, :commentid, :mediaid
  json.url record_url(record, format: :json)
end
