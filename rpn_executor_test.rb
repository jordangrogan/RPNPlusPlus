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

  # UNIT TEST FOR check_keyword_order
  # Return true if they are in the correct order (keyword at beginning)
  # Return the invalid keywords if they are in the incorrect order
  def test_check_keyword_order
    tokens = ["LET", "token1", "token2", "token3"]
    tokens_bad = ["token1", "LET", "token2", "token3"]
    tokens_bad_2 = ["token1", "token2", "LET", "token3"]
    assert @rpn.check_keyword_order(tokens)
    assert_equal @rpn.check_keyword_order(tokens_bad), "LET"
    assert_equal @rpn.check_keyword_order(tokens_bad_2), "LET"
  end

  # UNIT TEST FOR look_for_invalid_token

  # UNIT TEST FOR print_op

  # UNIT TEST for let_op

  # UNIT TEST FOR is_operator? FUNCTION
  # Test that it returns true when +, -, /, and * are input
  # Test that it returns false when +, -, /, and * are not an input
  def test_is_operator
    assert @rpn.is_operator?('+')
    assert @rpn.is_operator?('-')
    assert @rpn.is_operator?('/')
    assert @rpn.is_operator?('*')
    refute @rpn.is_operator?('1')
    refute @rpn.is_operator?('a')
  end

  # UNIT TEST FOR is_keyword? FUNCTION
  # Test that it returns true when "LET", "PRINT", and "QUIT" are input
  # Test that it returns false when "LET", "PRINT", and "QUIT" aren't input
  def test_is_keyword
    assert @rpn.is_keyword?('LET')
    assert @rpn.is_keyword?('PRINT')
    assert @rpn.is_keyword?('QUIT')
    refute @rpn.is_operator?('1')
    refute @rpn.is_operator?('a')
  end

  # UNIT TEST FOR is_var? FUNCTION
  # Test that it returns true when the input is a letter & only one character
  # Test that it returns false when the input is >1 character or a number
  def test_is_keyword
    assert @rpn.is_var?('a')
    refute @rpn.is_var?('longer_than_one_character')
    refute @rpn.is_var?('1')
  end

  # UNIT TEST FOR is_int? FUNCTION
  # Test that it returns true when the input is an integer
  # Test that it returns false when the input is not an integer
  def test_is_int
    assert @rpn.is_int?('1')
    assert @rpn.is_int?('10')
    refute @rpn.is_int?('a')
    refute @rpn.is_int?('longer_than_one_character')
  end

  # UNIT TESTS FOR calculate FUNCTION

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
