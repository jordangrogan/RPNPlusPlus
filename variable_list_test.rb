require 'minitest/autorun'

require_relative 'variable_list'

class VariableListTest < Minitest::Test

  def setup
    @variable_list = VariableList.new
  end

  # UNIT TESTS FOR variable_initialized?
  # Set a variable and test to see if it's initialized
  # Also test to see if an uninitialized variable returns false
  def test_variable_initialized
    @variable_list.set_variable("initialized", "value")
    assert @variable_list.variable_initialized?("initialized")
    refute @variable_list.variable_initialized?("not_initialized")
  end

  # UNIT TEST FOR get_ and set_variable
  # Set a variable and get it, then make sure those are equal
  def test_get_set_variable
    @variable_list.set_variable("test_name", "test_value")
    assert @variable_list.get_variable("test_name"), "test_value"
  end

end
