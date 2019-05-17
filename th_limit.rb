
770.times do |i|
  Thread.new do |s|
  	s = 1200 * 12312
  	sleep
  end
  puts i
rescue ThreadError
  puts "Your thread limit is #{i} threads"
  Kernel.exit(true)
end
