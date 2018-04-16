# Class for an error
class Error
  def initialize(message, error_code)
    @message = message
    @error_code = error_code
  end

  def error_message
    @message
  end

  def error_code
    @error_code
  end
end
