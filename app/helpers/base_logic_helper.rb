module BaseLogicHelper
	def readXLProxies
		workbook = RubyXL::Parser.parse 'proxy.xlsx'
		worksheet = workbook.worksheets[0]
		worksheet.each do |row|
			row_cells = row.cells.map{ |cell| cell.value }
			Proxy.create(ip: row_cells[0], port: row_cells[1]) if row_cells[0].size > 7
		end
	end

	def showProxies
		Proxy.each do |p|
			puts "#{p.ip}:#{p.port}"
		end

	end
	def pars1(link, proxy)
		a = Mechanize.new do |agent|
		 	#agent.user_agent_alias = 'Safari 4'
		 	agent.pre_connect_hooks << lambda do |agent, request|
		  		request['User-Agent'] = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0'
		  		request['Accept-Language'] = 'u-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3'
		  		request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
		  		#request['Accept-Encoding'] = 'gzip, deflate'
		  		#request['Cookie'] = 'wp-settings'
		  		#request['Connection'] = 'keep-alive'
		 	end
		end
		
		a.set_proxy(proxy.get_ip, proxy.get_port)

		doc = a.get(link) 

		proxy.setUsed if doc.body.length < 2000

		#doc = a.get('https://screencountry.com')

		puts doc.title
		doc.css('a').map do |links|
			#puts links.to_s
			Ilink.create(url: 'https://ru.mouser.com/' + links['href'], stype: 0) if links['href'].match('/.+\/_\/N-.+/')
		end
	end	

	def goPars
		#'https://ru.mouser.com/Electronic-Components/'
		pars1('d:/sites/FPGA - Field Programmable Gate Array _ Mouser Europe.html' , Proxy.where(status: nil).first)
	end

	def nokogiriPars
		
	end
end
