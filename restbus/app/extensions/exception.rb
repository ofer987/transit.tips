class Exception
  def full_message
    to_json
  end

  def to_json
    as_json.to_s
  end

  def as_json
    {
      message: message,
      backtrace: backtrace
    }
  end
end
