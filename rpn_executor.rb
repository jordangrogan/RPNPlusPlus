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
      if tokens[0] == 'QUIT'
        return "QUIT"
      end
      token_check = look_for_invalid_token(tokens)
      unless token_check == true
        return Error.new "Invalid token #{token_check} found in line"
      end
      # check to see there isn't a keyword not at the start of the line
      key_order = check_keyword_order(tokens)
      # if there was  keyword found at an invalid spot return an error
      unless key_order == true
        return Error.new "Keyword #{key_order} not at start of line"
      end
      if tokens[0] == 'LET'
        tokens.shift
        let_op(tokens)
      elsif tokens[0] == 'PRINT'
        tokens.shift
        print_op(tokens)
      elsif tokens[0] =~ /[A-Za-z]{2,}/
        return Error.new "Unknown keyword #{tokens[0]}"
      else
        return calculate(tokens)
      end

    end
  end

  # Returns the invalid keyword if keywords are incorrect order, true if they are
  def check_keyword_order(tokens)
    count = 0
    tokens.each do |token|
      if is_keyword?(token) && count > 0
        return token
      end
      count +=1
    end
    return true
  end

  # Returns invalid token if one is found, else returns true
  def look_for_invalid_token(tokens)
    tokens.each do |token|
      if !is_keyword?(token) && !is_var?(token) && !is_int?(token) && !is_operator?(token)
        return token
      end
    end
    return true
  end

  def print_op(tokens)
    val = calculate(tokens)
    if val.is_a?(Error)
      val
    else
      print val
    end

  end

  def let_op(tokens)
    variable_name = tokens.shift
    if tokens.empty?
      return "Operator LET applied to empty stack"
    end
    if is_var?(variable_name)
      @variables.set_variable(variable_name,calculate(tokens))
    else
      puts "invalid variable name"
    end

  end

  def is_number?(token)
    return true if token == '0' # token string is 0
    return false if token.to_i == 0 # to_i will return 0 if it's not a number
    return true
  end

  def is_operator?(token)
    return true if token == '+' || token == '-' || token == '/' || token == '*'
    return false
  end

  def is_keyword?(token)
    return true if token == "LET" || token == "PRINT" || token == "QUIT"
  end

  def is_var?(token)
    return true if token =~ /[[:alpha:]]{1}/ && token.bytesize == 1
  end

  def is_int?(token)
    chars = token.split("")
    chars.each do |char|
      match = char =~/[[:digit:]]/
      if match == nil
        return false
      end
    end
    return true
  end

  def calculate(tokens)
    operator = nil
    operand1 = nil
    operand2 = nil
    result = nil


    stack = LineStack.new()
    tokens.each do |token|
      if is_operator?(token)
        operand1 = stack.pop
        operand2 = stack.pop
        if operand1 == nil || operand2 == nil
          return Error.new "Operator #{token} applied to empty stack"
        end
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
      else
        #puts "Token is #{token}"
        if is_var?(token)
          unless @variables.check_for_variable(token)
            return Error.new "Variable #{token} is not initialized"
          end
          stack.push(@variables.get_variable(token))
        elsif is_number?(token)
          stack.push(token.to_i)
        end
      end
    end
    if stack.get_num_items > 1
      return Error.new "#{stack.get_num_items} elements in stack after evaluation"
    else
      return stack.pop
    end
  end

end
