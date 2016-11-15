class Report < ActiveModelSerializers::Model
  alias :read_attribute_for_serialization :send

  attr_accessor :statuses

  def initialize(attributes)
    @statuses = Array(attributes[:statuses])

    super(attributes)
  end

  def condition
    statuses.each do |status|
      return :red unless Analyser.new.smooth_road?(status.description)
    end

    :green
  end
end
