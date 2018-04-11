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

  value = nil;
  while(value != "QUIT")
    print '> '
    value = rpn.execute(gets.chomp.upcase)
    puts value if value != "QUIT"
  end

end
