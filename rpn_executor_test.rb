require 'minitest/autorun'

require_relative 'rpn_executor'

class RPNExecutorTest < Minitest::Test

  def setup
    @rpn = RPNExecutor.new
  end

  def test_adding
    assert_output("7\n") { @rpn.execute("4 3 +") }
  end

end
