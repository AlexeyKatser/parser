def raise_and_rescue  
	puts 'before begin'
  begin  
    puts 'I am before the raise.'  
    #raise 'An error has occured.'  
    puts 'I am after the raise.'  
  rescue  
    puts 'I am rescued.'
    return 'return'   
  end  
  puts 'I am after the begin block.'  
end  
puts raise_and_rescue  