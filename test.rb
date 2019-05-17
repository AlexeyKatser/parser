def dadad
	puts 'def'
	begin 
		fa = rand 20
		p fa
		retry if fa < 10
	end
end

dadad()