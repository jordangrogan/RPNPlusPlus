class RPN

  def execute(line)
    puts line
  end

end

# Main Execution Begins Here

rpn = RPN.new

if ARGV.count > 0
  # File mode

  lines = []
  File.open(ARGV[0], "r").each_line do |line|
    lines << line.chomp.upcase
    execute(line)
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
