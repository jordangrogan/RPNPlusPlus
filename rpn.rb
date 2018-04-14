require_relative 'rpn_executor'

trap "SIGINT" do exit end # Handle quitting with control-C gracefully

rpn = RPNExecutor.new

if ARGV.count > 0
  # File mode

    value = nil
    ARGV.each do |file|
      File.open(file, 'r').each_line do |line|
        value = rpn.execute(line.upcase)
        if(value).is_a?(Error)
          puts "Line #{i}: #{value.error_message}"
        else
          value
        end
        break if value == "QUIT"
      end
      break if value == "QUIT"
    end

else
  # REPL mode

  value = nil
  line_count = 0
  while(value != "QUIT")
    line_count += 1
    print '> '
    value = rpn.execute(gets.chomp.upcase)
    if(value).is_a?(Error)
      puts "Line #{line_count}: #{value.error_message}"
    end
    puts value if value != "QUIT" && !value.is_a?(Error)
  end

end
