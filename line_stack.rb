require_relative 'error'

# Class for each line's call stack
class LineStack
  def initialize()
    @stack = []
  end

  def push item
    @stack.push(item)
  end

  def peek
    @stack.last
  end

  def pop
    @stack.pop
  end

end
