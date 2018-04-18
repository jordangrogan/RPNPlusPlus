require 'minitest/autorun'
require 'rantly/minitest_extensions'

require_relative 'rpn_executor'

class RPNExecutorTest < Minitest::Test

  def setup
    @rpn = RPNExecutor.new
  end

  # UNIT TESTS for execute
  # Equivlence classes:
  # Blank line -> Return ''
  # Keywords out of order -> Return Error
  # First token 'QUIT' -> Return 'QUIT'
  # First token a string that is exactly 2 or more alpha chars -> Return Error
  # First token 'LET' -> Return value of let_op (no way to test)
  # First token 'PRINT' -> Return value of print_op (no way to test)
  # First token is a number or single letter -> Return value of calculate (no way to test)

  def test_execute_blank_line
    assert_equal @rpn.execute(''), ''
  end

  def test_execute_keyword_out_of_order
    assert_kind_of Error, @rpn.execute("4 3 LET + a")
  end

  def test_first_token_quit
    assert_equal @rpn.execute('QUIT BUMBLEBEE'), 'QUIT'
  end

  def test_first_token_longer_than_two_alpha_chars
    assert_kind_of Error, @rpn.execute("TEST")
  end

  # UNIT TESTS FOR check_keyword_order
  # Equivalence classes:
  # Return true if they are in the correct order (keyword at beginning)
  # Return the invalid keywords if they are in the incorrect order

  def test_check_keyword_order_correct
    tokens = ["LET", "token1", "token2", "token3"]
    assert @rpn.check_keyword_order(tokens)
  end

  def check_keyword_order_incorrect
    tokens_bad = ["token1", "LET", "token2", "token3"]
    tokens_bad_2 = ["token1", "token2", "LET", "token3"]
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

  # UNITS TEST FOR operator? FUNCTION
  # Equivalence classes:
  # When +, -, /, and * are input -> Return true
  # When +, -, /, and * are not an input -> Return false

  def test_operator_valid
    assert @rpn.operator?('+')
    assert @rpn.operator?('-')
    assert @rpn.operator?('/')
    assert @rpn.operator?('*')
  end

  def test_operator_invalid
    refute @rpn.operator?('1')
    refute @rpn.operator?('a')
  end

  # UNIT TESTS FOR keyword? FUNCTION
  # Equivalence classes:
  # When "LET", "PRINT", and "QUIT" are input -> Return true
  # When "LET", "PRINT", and "QUIT" aren't input -> Return false

  def test_keyword_valid
    assert @rpn.keyword?('LET')
    assert @rpn.keyword?('PRINT')
    assert @rpn.keyword?('QUIT')
  end

  def test_keyword_invalid
    refute @rpn.keyword?('1')
    refute @rpn.keyword?('a')
  end

  # UNIT TESTS FOR var? FUNCTION
  # Equivalence classes:
  # When the input is a letter & only one character -> Return true
  # When the input is >1 character or a number -> Return false

  def test_var_valid
    assert @rpn.var?('a')
  end

  def test_var_invalid
    refute @rpn.var?('longer_than_one_character')
    refute @rpn.var?('1')
  end

  # UNIT TESTS FOR int? FUNCTION
  # Equivalence classes:
  # When the input is an integer -> Return true
  # When the input is not an integer -> Return false

  def test_int_valid
    assert @rpn.int?('1')
    assert @rpn.int?('10')
    assert @rpn.int?('100')
  end

  def test_int_invalid
    refute @rpn.int?('a')
    refute @rpn.int?('1a')
    refute @rpn.int?('a1')
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
