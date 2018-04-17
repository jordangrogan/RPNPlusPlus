# Class for an error
class Error
  attr_reader :error_message, :error_code

  def initialize(error_message, error_code)
    @error_message = error_message
    @error_code = error_code
  end
end
