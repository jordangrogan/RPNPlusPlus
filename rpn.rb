require_relative 'rpn_executor'

rpn = RPNExecutor.new

if ARGV.count > 0
  # File mode

    ARGV.each do |file|
      File.open(file, 'r').each_line do |line|
        rpn.execute(line.upcase)
      end
    end

else
  # REPL mode

  loop do
    print '> '
    rpn.execute(gets.chomp.upcase)
  end

end
