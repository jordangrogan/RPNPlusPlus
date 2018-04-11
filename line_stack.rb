require_relative 'error'

# Class for each line's call stack
class LineStack
  def initialize(line)
    @stack = []
    @line = line

    # add line to the line stack
    tokens = line.split(' ')
    tokens.each do |token|
      @stack.push(token)
    end
  end

  def check_syntax_errors
    # checks for syntax errors
    # return Error.new("Here's the error")

    # no errors
    return nil
  end

  def peak
    @stack.last
  end

  def pop
    @stack.pop
  end

end
