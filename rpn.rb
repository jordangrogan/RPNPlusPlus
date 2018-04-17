require_relative 'rpn_executor'

rpn = RPNExecutor.new

if ARGV.count > 0
  # File mode

  value = nil
  line_count = 0
  ARGV.each do |file|
    begin
      File.open(file, 'r').each_line do |line|
        line_count += 1
        value = rpn.execute(line.upcase)
        if value.is_a?(Error)
          puts "Line #{line_count}: #{value.error_message}"
          exit value.error_code
        end
        break if value == 'QUIT'
      end
    rescue Errno::ENOENT
      puts 'File not found.'
    end
    break if value == 'QUIT'
  end

else
  # REPL mode

  line_count = 0
  while value != 'QUIT'
    line_count += 1
    print '> '
    begin
      value = rpn.execute(gets.chomp.upcase)
    rescue Interrupt, Exception # Handle ctrl-c and ctrl-d
      puts ''
      value = 'QUIT'
    end
    puts "Line #{line_count}: #{value.error_message}" if value.is_a?(Error)
    puts value if value != 'QUIT' && !value.is_a?(Error) && value != ''
  end

end
