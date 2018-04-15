require 'minitest/autorun'

require_relative 'error'

class ErrorTest < Minitest::Test

  # UNIT TEST to make sure an error can be created with a message
  # Tests initialize and error_message functions
  def test_create_error
    error = Error.new "A test error message"
    assert_equal error.error_message, "A test error message"
  end

end
