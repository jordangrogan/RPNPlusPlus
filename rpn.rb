if ARGV.count > 0

  # File mode
  lines = []
  File.open(ARGV[0], "r").each_line do |line|
    lines << line.chomp
    puts line
  end

else
  # REPL mode
end
