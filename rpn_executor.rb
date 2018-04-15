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
      # check if the user entered quit before anything else
      if tokens[0] == 'QUIT'
        return "QUIT"
      end
      # create a boolean to check for basic invalid tokens
      token_check = look_for_invalid_token(tokens)
      unless token_check == true
        # if an invalid token was found then return it and report the error
        return Error.new "Invalid token #{token_check} found in line"
      end
      # check to see there isn't a keyword not at the start of the line
      key_order = check_keyword_order(tokens)
      # if there was  keyword found at an invalid spot return an error
      unless key_order == true
        return Error.new "Keyword #{key_order} not at start of line"
      end
      # at this point there are no invalid tokens and keywords are in correct order
      # check to see which keyword is used if one is used
      if tokens[0] == 'LET'
        tokens.shift
        let_op(tokens)
      elsif tokens[0] == 'PRINT'
        tokens.shift
        print_op(tokens)
      # this may not actually get hit ever because look_for_invalid_token should catch this I believe
      elsif tokens[0] =~ /[A-Za-z]{2,}/
        return Error.new "Unknown keyword #{tokens[0]}"
      else
        # If no keyword is used then just perform a calculation
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
    count = 0
    tokens.each do |token|
      if !is_keyword?(token) && !is_var?(token) && !is_int?(token) && !is_operator?(token) && count > 0
        return token
      end
    end
    return true
  end
  # will print out the result of the RPN expression passed to calculate
  # unless an error is returned
  def print_op(tokens)
    value = calculate(tokens)
    if value.is_a?(Error)
      return value
    else
      puts value
      return ""
    end

  end

  # will set the variable being LET equal to the following rpn expression
  def let_op(tokens)
    variable_name = tokens.shift
    # if the stack is empty here return an error
    if tokens.empty?
      return Error.new "Operator LET applied to empty stack"
    end
    # if the variable is a valid var name, pass the rpn expression
    # to calculate and set it equal to its return value
    if is_var?(variable_name)
      @variables.set_variable(variable_name,calculate(tokens))
    else
      return Error.new "Invalid variable name"
    end

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

  # checking if a token is an integer
  def is_int?(token)
    # split the token into a character array, and check every character
    # to verify it is a digit, if any character is not a digit return false
    chars = token.split("")
    chars.each do |char|
      match = char =~/[[:digit:]]/
      if match == nil
        return false
      end
    end
    return true
  end

  # will take any RPN expression and return its result
  # will return an error if the expression is improper
  def calculate(tokens)
    operator = nil
    operand1 = nil
    operand2 = nil
    result = nil


    stack = LineStack.new()
    tokens.each do |token|
      # if the token is an operator, pop two operands off the stack
      # and calculate the result based on which operator is being used
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
        # push the result onto the stack
        stack.push(result)
      else
        # if the token is not an operator check if it is a valid variable name
        if is_var?(token)
          # if the variable is uninitialized return an error
          unless @variables.variable_initialized?(token)
            return Error.new "Variable #{token} is not initialized"
          end
          # if the variable is valid and initialized, push its value onto the stack
          stack.push(@variables.get_variable(token))
        # if the token is not a variable, make sure it is an integer and push it onto the stack
        elsif is_int?(token)
          stack.push(token.to_i)
        end
      end
    end
    # if the calculation is complete and there is more than one item on the stack return an error
    if stack.num_items > 1
      return Error.new "#{stack.num_items} elements in stack after evaluation"
    else
      # return the result by popping it off the stack
      return stack.pop
    end
  end

end
