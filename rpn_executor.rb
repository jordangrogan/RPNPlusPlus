# Class for RPN programming language
class RPNExecutor
  def initialize
    @variables = VariableList.new
  end

  def execute(line)

    stack = LineStack.new(line)
    error = stack.check_syntax_errors
    return error unless error.is_nil?

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

  def is_number?(token)
    return true if token == '0' # token string is 0
    return false if token.to_i == 0 # to_i will return 0 if it's not a number
    return true
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
      add_op(stack)
    elsif operator == '-'
      subt_op
    elsif operator == '*'
      mult_op
    elsif operator == '/'
      div_op
    end
  end

  def add_op(stack)
    operand1 = stack.pop
    operand2 = stack.pop

    # Check to see if operands are numbers, if they are not, check if they are variables, if they are not, throw error
    operand1 = @variables.check_for_variable(operand1)
    return if operand1.is_a?(Error)

    if is_number?(operand2)
      operand2 = operand2.to_i
    elsif @variables.variable_exist?(operand2)
      operand2 = @variables[operand2].to_i
    else
      print "Variable #{operand2} is not initialized"
      return
    end

    operand1 + operand2
  end

  def subt_op
    operand1 = @call_stack.pop
    operand2 = @call_stack.pop

    # Check to see if operands are numbers, if they are not, check if they are variables, if they are not, throw error
    operand1 = operand1.to_i
    operand2 = operand2.to_i

    operand2 - operand1
  end

  def mult_op
    operand1 = @call_stack.pop
    operand2 = @call_stack.pop

    # Check to see if operands are numbers, if they are not, check if they are variables, if they are not, throw error
    operand1 = operand1.to_i
    operand2 = operand2.to_i

    operand1 * operand2
  end

  def div_op
    operand1 = @call_stack.pop
    operand2 = @call_stack.pop

    # Check to see if operands are numbers, if they are not, check if they are variables, if they are not, throw error
    operand1 = operand1.to_i
    operand2 = operand2.to_i

    operand2 / operand1
  end
end
