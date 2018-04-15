require_relative 'rpn_executor'

rpn = RPNExecutor.new

if ARGV.count > 0
  # File mode

  value = nil
  ARGV.each do |file|
    File.open(file, 'r').each_line do |line|
      value = rpn.execute(line.upcase)
      puts "Line #{i}: #{value.error_message}" if value.is_a?(Error)
      break if value == 'QUIT'
    end
    break if value == 'QUIT'
  end

else
  # REPL mode

  line_count = 0
  while value != 'QUIT'
    line_count += 1
    print '> '
    value = rpn.execute(gets.chomp.upcase)
    puts "Line #{line_count}: #{value.error_message}" if value.is_a?(Error)
    puts value if value != 'QUIT' && !value.is_a?(Error) && value != ""
  end

end
