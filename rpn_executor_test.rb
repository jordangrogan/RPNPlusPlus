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

  # TODO: UNIT TESTS for execute

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

  # UNIT TESTS FOR print_op
  # Equivalence classes:
  # Tokens are a valid expression -> print value & return ""
  # Tokens are not a valid expression -> print nothing & return error

  def test_print_op_valid_expression
    assert_output("2\n") { @rpn.print_op(['1', '1', '+']) }
    assert_equal @rpn.print_op(['1', '1', '+']), ""
  end

  def test_print_op_invalid_expression
    assert_output("") { @rpn.print_op(['1', '1', '+' '+']) }
    assert_kind_of Error, @rpn.print_op(['1', '1', '+' '+'])
  end

  # UNIT TESTS for let_op
  # Equivalence classes:
  # Tokens are valid expression -> Return & set variable equal to expression
  # Tokens are invalid expression -> Return error
  # Variable name is invalid -> Return error

  def test_let_op_valid_expression
    value = @rpn.let_op(['a', '1'])
    assert_equal value, 1
    value = @rpn.let_op(['a', '1', '1', '+'])
    assert_equal value, 2
  end

  def test_let_op_invalid_expression
    value = @rpn.let_op(['a'])
    assert_kind_of Error, value
    value = @rpn.let_op(['a', '1', '+'])
    assert_kind_of Error, value
  end

  def test_let_op_variable_name_invalid
    value = @rpn.let_op(['test', '1'])
    assert_kind_of Error, value
  end


  # UNIT TEST FOR operator? FUNCTION
  # Test that it returns true when +, -, /, and * are input
  # Test that it returns false when +, -, /, and * are not an input
  def test_is_operator
    assert @rpn.operator?('+')
    assert @rpn.operator?('-')
    assert @rpn.operator?('/')
    assert @rpn.operator?('*')
    refute @rpn.operator?('1')
    refute @rpn.operator?('a')
  end

  # UNIT TEST FOR keyword? FUNCTION
  # Test that it returns true when "LET", "PRINT", and "QUIT" are input
  # Test that it returns false when "LET", "PRINT", and "QUIT" aren't input
  def test_is_keyword
    assert @rpn.keyword?('LET')
    assert @rpn.keyword?('PRINT')
    assert @rpn.keyword?('QUIT')
    refute @rpn.keyword?('1')
    refute @rpn.keyword?('a')
  end

  # UNIT TEST FOR var? FUNCTION
  # Test that it returns true when the input is a letter & only one character
  # Test that it returns false when the input is >1 character or a number
  def test_is_keyword
    assert @rpn.var?('a')
    refute @rpn.var?('longer_than_one_character')
    refute @rpn.var?('1')
  end

  # UNIT TEST FOR int? FUNCTION
  # Test that it returns true when the input is an integer
  # Test that it returns false when the input is not an integer
  def test_is_int
    assert @rpn.int?('1')
    assert @rpn.int?('10')
    refute @rpn.int?('a')
    refute @rpn.int?('longer_than_one_character')
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

  # Test for integer overflow, per requirement 3
  #    999999999999999999999999999
  # +  999999999999999999999999999
  # ______________________________
  # = 1999999999999999999999999998
  def test_integer_overflow
    x = 999999999999999999999999999
    y = 999999999999999999999999999
    assert_equal @rpn.calculate([x.to_s, y.to_s, '+']), 1999999999999999999999999998
  end

end
