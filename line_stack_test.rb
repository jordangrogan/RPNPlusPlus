require 'minitest/autorun'

require_relative 'line_stack'

class LineStackTest < Minitest::Test

  def setup
    @line_stack = LineStack.new
  end

  # UNIT TEST for pushing and popping off the stack
  # Push two items on, pop one item off
  # Assert that there is only one item after it has been popped off
  def test_push_pop
    @line_stack.push("1")
    @line_stack.push("2")
    assert_equal @line_stack.pop, "2"
    assert_equal @line_stack.num_items, 1
  end

  # UNIT TEST for peeking (seeing what the top item on the stack is)
  # Also assert that there's still two items on the stack after peeking
  def test_peek
    @line_stack.push("1")
    @line_stack.push("2")
    assert_equal @line_stack.peek, "2"
    assert_equal @line_stack.num_items, 2
  end

  # UNIT TEST for getting the number of items
  # Push on two items, make sure there are 2
  def test_num_items
    @line_stack.push("1")
    @line_stack.push("2")
    assert_equal @line_stack.num_items, 2
  end

end
