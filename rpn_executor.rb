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

    # Check for a blank line, return ''
    return '' if tokens.empty?

    # check if the user entered quit before anything else
    return 'QUIT' if tokens[0] == 'QUIT'

    # check to see there isn't a keyword not at the start of the line
    key_order = check_keyword_order(tokens)
    unless key_order == true
      return Error.new("Keyword #{key_order} not at start of line", 5)
    end

    if tokens[0] == 'LET'
      tokens.shift
      let_op(tokens)
    elsif tokens[0] == 'PRINT'
      tokens.shift
      print_op(tokens)
    elsif tokens[0] =~ /[A-Za-z]{2,}/
      return Error.new("Unknown keyword #{tokens[0]}", 4)
    else
      # If no keyword is used & the first token is not
      # longer than one character, just perform a calculation
      return calculate(tokens)
    end
  end

  # Returns the invalid keyword if keywords are incorrect order,
  # true if they are
  def check_keyword_order(tokens)
    count = 0
    tokens.each do |token|
      return token if keyword?(token) && count > 0
      count += 1
    end
    true
  end

  # will print out the result of the RPN expression passed to calculate
  # unless an error is returned
  def print_op(tokens)
    value = calculate(tokens)
    return value if value.is_a?(Error)
    puts value
    ''
  end

  # will set the variable being LET equal to the following rpn expression
  def let_op(tokens)
    variable_name = tokens.shift
    # if the stack is empty here return an error
    return Error.new('Operator LET applied to empty stack', 2) if tokens.empty?
    # if the variable is a valid var name, pass the rpn expression
    # to calculate and set it equal to its return value
    if var?(variable_name)
      value = calculate(tokens)
      @variables.set_variable(variable_name, value) unless value.is_a?(Error)
      value
    else
      Error.new('Invalid variable name', 5)
    end
  end

  # Returns true if token is an operator, else returns false
  def operator?(token)
    return true if ['+', '-', '/', '*'].include?(token)
    false
  end

  # Returns true if token is a keyword, else returns false
  def keyword?(token)
    return true if %w[LET PRINT QUIT].include?(token)
  end

  # Returns true if token is a valid variable, else returns false
  def var?(token)
    return true if token =~ /[[:alpha:]]{1}/ && token.length == 1
  end

  # Returns true if token is a number, else returns false
  def int?(token)
    # split the token into a character array, and check every character
    # to verify it is a digit, if any character is not a digit return false
    chars = token.split('')
    count = 0
    chars.each do |char|
      match = char =~ /[[:digit:]]/
      is_neg = char =~ /(-)/
      next if count.zero? && !is_neg.nil?
      return false if match.nil?
      count += 1
    end
    true
  end

  # will take any RPN expression and return its result
  # will return an error if the expression is improper
  def calculate(tokens)
    stack = LineStack.new
    tokens.each do |token|
      # if the token is an operator, pop two operands off the stack
      # and calculate the result based on which operator is being used
      if operator?(token)
        operand1 = stack.pop
        operand2 = stack.pop
        if operand1.nil? || operand2.nil?
          return Error.new("Operator #{token} applied to empty stack", 2)
        end

        result = operand1 + operand2 if token == '+'
        result = operand2 - operand1 if token == '-'
        result = operand1 * operand2 if token == '*'
        result = operand2 / operand1 if token == '/'

        # push the result onto the stack
        stack.push(result)
        # if the token is not an operator check if it is a valid variable name
      elsif var?(token)
        # if the variable is uninitialized return an error
        unless @variables.variable_initialized?(token)
          return Error.new("Variable #{token} is not initialized", 1)
        end
        # if the variable is valid and initialized,
        # push its value onto the stack
        stack.push(@variables.get_variable(token))
        # if the token is not a variable, make sure it is an integer
        # and push it onto the stack
      elsif int?(token)
        stack.push(token.to_i)
      else
        return Error.new('Invalid syntax', 5)
      end
    end
    # if the calculation is complete and there is more than one
    # item on the stack return an error
    er = Error.new("#{stack.num_items} elements in stack after evaluation", 3)
    return er if stack.num_items > 1

    # return the result by popping it off the stack
    stack.pop
  end
end
