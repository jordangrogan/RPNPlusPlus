class RPN

  def initialize
    @call_stack = []
    @variables = {}
  end

  def execute(line)

    tokens = line.split (" ")

    if(tokens.size > 0)

      if(tokens[0] == "LET")
        @variables[tokens[1]] = tokens[2]
      end

      if(tokens[0] == "PRINT")
        print_op(tokens[1,tokens.length])
      end

    end

  end

  def print_op(arr)
    if(arr.size == 1)
      print arr
    else
      arr.each do |token|
        @call_stack.push(token)
      end
      if(@call_stack.pop == "+")
        puts @variables[@call_stack.pop].to_i + @variables[@call_stack.pop].to_i
      end
    end
  end

end

# Main Execution Begins Here

rpn = RPN.new

if ARGV.count > 0
  # File mode

  lines = []
  File.open(ARGV[0], "r").each_line do |line|
    lines << line.chomp.upcase
    rpn.execute(line)
  end

else
  # REPL mode

  input = nil
  while(input != "QUIT")
    print "> "
    input = gets().chomp.upcase
    rpn.execute(input)
  end

end
