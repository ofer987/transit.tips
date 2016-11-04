class Line
  class << self
    def find_statuses(id)
      Status.where(line_id: id)
    end
  end
end
