# Class for RPN programming language
class RPNExecutor
  def initialize
    @call_stack = []
    @variables = {}
  end

  def execute(line)
    tokens = line.split(' ')

    unless tokens.empty?

      if tokens[0] == 'LET'
        let_op(tokens[1, tokens.length])
      elsif tokens[0] == 'PRINT'
        print_op(tokens[1, tokens.length])
      elsif tokens[0] == 'QUIT'
        exit # bad, will affect testing code
      else
        tokens.each do |token|
          @call_stack.push(token)
        end
        calculate
      end

    end
  end

  def print_op(arr)

    if arr.size == 1
      puts arr[0]
    else

      arr.each do |token|
        @call_stack.push(token)
      end

      puts calculate

    end
  end

  def let_op(arr)
    arr.each do |token|
      @call_stack.push(token)
    end

    if(is_operator?(@call_stack.last))
      value = calculate
    else
      value = @call_stack.pop
    end

    variable_name = @call_stack.pop
    @variables[variable_name] = value
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

  def calculate
    operator = @call_stack.pop
    if operator == '+'
      add_op
    elsif operator == '-'
      subt_op
    elsif operator == '*'
      mult_op
    elsif operator == '/'
      div_op
    end
  end

  def add_op
    operand1 = @call_stack.pop
    operand2 = @call_stack.pop

    # Check to see if operands are numbers, if they are not, check if they are variables, if they are not, throw error
    if is_number?(operand1)
      operand1 = operand1.to_i
    elsif @variables.key?(operand1)
      operand1 = @variables[operand1].to_i
    else
      print "Variable #{operand1} is not initialized"
      return
    end
    if is_number?(operand2)
      operand2 = operand2.to_i
    elsif @variables.key?(operand2)
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
