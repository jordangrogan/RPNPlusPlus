require_relative 'rpn_executor'

trap "SIGINT" do exit end # Handle quitting with control-C gracefully

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
    puts rpn.execute(gets.chomp.upcase)
  end

end
