# Class for each line's call stack
class LineStack
  def initialize(line)
    @stack = []
    # add line to the line stack
  end

  def check_syntax_errors
    # checks for syntax errors
    return Error.new("Here's the error")

    # no errors
    return nil
  end

end
