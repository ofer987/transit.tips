class StatusSerializer < ActiveModel::Serializer
  attributes :line_id, :line_type, :description, :tweeted_at
end
