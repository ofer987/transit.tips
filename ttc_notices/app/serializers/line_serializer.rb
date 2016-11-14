class LineSerializer < ActiveModel::Serializer
  attributes :id

  has_many :statuses
  # class StatusSerializer < ActiveModel::Serializer
  #   attributes :line_id, :line_type, :description, :tweeted_at
  # end
end
