class HttpStatusError < StandardError
  attr_reader :code, :message, :backtrace

  def initialize(code, message)
    self.code = code
    self.message = message
  end

  def as_json
    {
      code: self.code,
      message: self.message,
      backtrace: backtrace
    }
  end

  private

  attr_writer :code, :message
end
