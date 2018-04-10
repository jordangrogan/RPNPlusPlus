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
        @variables[tokens[1]] = tokens[2]
      end

      if tokens[0] == 'PRINT'
        print_op(tokens[1, tokens.length])
      end

      if tokens[0] == 'QUIT'
        exit
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
      if @call_stack.pop == '+'
        puts @variables[@call_stack.pop].to_i + @variables[@call_stack.pop].to_i
      end
    end
  end
end
