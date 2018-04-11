require_relative 'rpn_executor'

trap "SIGINT" do exit end # Handle quitting with control-C gracefully

rpn = RPNExecutor.new

if ARGV.count > 0
  # File mode

    ARGV.each do |file|
      File.open(file, 'r').each_line do |line|
        value = rpn.execute(line.upcase)
        if(value).is_a?(Error)
          puts "Line #{i}: #{value.print_error}"
        else
          value
        end
      end
    end

else
  # REPL mode

  loop do
    print '> '
    puts rpn.execute(gets.chomp.upcase)
  end

end
