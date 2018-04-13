require_relative 'variable_list'
require_relative 'line_stack'
require_relative 'error'

# Class for RPN programming language
class RPNExecutor
  def initialize
    @variables = VariableList.new
  end

  def execute(line)
    tokens = line.split(' ')

    unless tokens.empty?

      if tokens[0] == 'LET'
        let_op(stack)
      elsif tokens[0] == 'PRINT'
        print_op(stack)
      elsif tokens[0] == 'QUIT'
        "QUIT"
      else
        puts calculate(line)
      end

    end
  end

  # def print_op(stack)
  #
  #   if arr.size == 1
  #     puts arr[0]
  #   else
  #   end
  # end

  # def let_op(stack)
  #   if(is_operator?(stack.peek))
  #     value = calculate(stack)
  #   else
  #     value = stack.pop
  #   end
  #
  #   variable_name = stack.pop
  #   stack[variable_name] = value
  # end

  def is_operator?(token)
    return true if token == '+' || token == '-' || token == '/' || token == '*'
    return false
  end

  def calculate(line)
    operator = nil
    operand1 = nil
    operand2 = nil
    result = nil

    tokens = line.split(' ')
    stack = LineStack.new()
    tokens.each do |token|
      if is_operator?(token)
        operand1 = stack.pop
        operand2 = stack.pop
        if token == '+'
          result = operand1 + operand2
        elsif token == '-'
          result = operand2 - operand1
        elsif token == '*'
          result = operand1 * operand2
        elsif token == '/'
          result = operand2 / operand1
        end
        stack.push(result)
      else #assume constant operand for now
        stack.push(token.to_i)
      end
    end
    return stack.pop
  end

end
