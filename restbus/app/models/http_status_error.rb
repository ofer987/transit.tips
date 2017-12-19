class HttpStatusError < StandardError
  attr_reader :code, :message

  def initialize(code, message)
    self.code = code
    self.message = message
  end

  private

  attr_writer :code, :message
end
