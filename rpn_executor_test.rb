require 'minitest/autorun'
require 'rantly/minitest_extensions'

require_relative 'rpn_executor'

class RPNExecutorTest < Minitest::Test

  def setup
    @rpn = RPNExecutor.new
  end

  # System Level Testing
  # def test_adding
  #   assert_equal 7, @rpn.execute("4 3 +")
  # end

  # UNIT TESTS FOR is_operator? FUNCTION

  # Test that it returns true when +, -, /, are * are input
  def test_is_operator
    assert @rpn.is_operator?('+')
    assert @rpn.is_operator?('-')
    assert @rpn.is_operator?('/')
    assert @rpn.is_operator?('*')
  end

  # Test that it returns false when +, -, /, are * are not an input
  def test_is_operator_not_an_operator
    refute @rpn.is_operator?('1')
    refute @rpn.is_operator?('a')
  end

  # UNIT TESTS FOR CALCULATE

  # Test a sample operation
  def test_calculate
    tokens = "10 10 * 5 5 * 0 0 * + +".split(' ')
    assert @rpn.calculate(tokens), 125
  end

  # Use property based testing to ensure calculations are correct
  def test_calculate_property_based
    property_of {
      x = integer
      y = integer
      [x, y]
    }.check { |x, y|
      sum = x + y
      diff = y - x
      prod = x * y
      quot = y/x
      assert @rpn.calculate([x.to_s, y.to_s, '+']), sum
      assert @rpn.calculate([x.to_s, y.to_s, '-']), diff
      assert @rpn.calculate([x.to_s, y.to_s, '*']), prod
      assert @rpn.calculate([x.to_s, y.to_s, '/']), quot
    }
  end

end
