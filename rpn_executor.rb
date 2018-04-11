require_relative 'variable_list'
require_relative 'line_stack'
require_relative 'error'

# Class for RPN programming language
class RPNExecutor
  def initialize
    @variables = VariableList.new
  end

  def execute(line)

    stack = LineStack.new(line)
    error = stack.check_syntax_errors
    return error unless error.nil?

    tokens = line.split(' ')

    unless tokens.empty?

      if tokens[0] == 'LET'
        let_op(stack)
      elsif tokens[0] == 'PRINT'
        print_op(stack)
      elsif tokens[0] == 'QUIT'
        "QUIT"
      else
        calculate(stack)
      end

    end
  end

  def print_op(stack)

    if arr.size == 1
      puts arr[0]
    else

    puts calculate

    end
  end

  def let_op(stack)
    if(is_operator?(stack.peak))
      value = calculate(stack)
    else
      value = stack.pop
    end

    variable_name = stack.pop
    stack[variable_name] = value
  end

  def is_operator?(token)
    return true if token == '+' || token == '-' || token == '/' || token == '*'
    return false
  end

  def calculate(stack)
    operator = stack.pop
    operand1 = stack.pop
    operand2 = stack.pop

    operand1 = @variables.check_for_variable(operand1)
    return if operand1.is_a?(Error)

    operand2 = @variables.check_for_variable(operand2)
    return if operand2.is_a?(Error)

    if operator == '+'
      operand1 + operand2
    elsif operator == '-'
      operand2 - operand1
    elsif operator == '*'
      operand1 * operand2
    elsif operator == '/'
      operand2 / operand1
    end
  end

end
