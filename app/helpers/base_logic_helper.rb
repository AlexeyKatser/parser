
module BaseLogicHelper
	Site = 'https://mouser.com'
	$maxLinkID = 0
	#$tProxies = Proxy.where(status: nil, used: nil)

	def loadProxies
		$tProxies = Proxy.where(status: nil)
		setLoadedProxiesUnused
		return 'loaded!'
	end

	def getProxy
		loadProxies if $tProxies == nil
		$tProxies.each do |pr|
			return pr if pr.used == nil && pr.status == nil
		end
		return nil
	end

	def workingProxiesLeft
		count = 0
		$tProxies.each do |pr|
			count += 1 if pr.status == nil
		end
		return count
	end

	def readXLProxies
		workbook = RubyXL::Parser.parse 'proxy.xlsx'
		worksheet = workbook.worksheets[0]
		worksheet.each do |row|
			if row != nil
				row_cells = row.cells.map{ |cell| cell.value }
				Proxy.create(ip: row_cells[0], port: row_cells[1]) if row_cells[0].size > 7
			end
		end
		return 1
	end

	def showProxies
		Proxy.each do |pr|
			puts "#{pr.ip}:#{pr.port}"
		end
	end

	def saveProxies
		Proxy.transaction do
				$tProxies.each do |pr|
					pr.used = false
					pr.save!
			end	
		end
		return 'Proxies saved'
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
		
		begin
			a.set_proxy(proxy.getIP, proxy.getPort)
			doc = a.get(link.url) 
		rescue StandardError => e
			#proxy.setUnworking
			proxy.status = 1
			return -1
		end

		if (doc == nil || doc.body.length < 2000 || doc.title == nil)
			#proxy.setUnworking
			proxy.status = 1
			p 'Proxy banned!'
			return -1
		end

		all_links = doc.css('a')
		#puts all_links.count
		return -1 if all_links.count == 0

		Ilink.transaction do
			all_links.each do |ilink|
				if ilink['href'] != nil
					if ilink['href'].match('/.+\/_\/N-.+/')	
						href = ilink['href']
						href = Site + href unless href.include?("https:")
						Ilink.create(url: href, stype: 0) 
					end
				end
			end
		end

		return -1 if parsItems(doc) == -1
		link.with_lock do
			link.setDone
		end
		proxy.timeUsed = 0 if proxy.timeUsed == nil
		proxy.timeUsed = proxy.timeUsed + 1
		proxy.used = nil
		#	proxy.incDone
		return 1
	end	

	def goPars
		#puts 'https://ru.mouser.com/Electronic-Components/'
		links = Ilink.where('done is null and stype = 0 and id > ?', $maxLinkID).first(100)
		if links.count == 0
			return 'nothing to do here'
		end
		threads = []
		repeat = false
		noProxy = false
		links.each do |l|
			sleep 1
			pr = getProxy
			if pr == nil
				break if workingProxiesLeft > 0					
			end
			pr.used = true

			$maxLinkID = l.id if l.id > $maxLinkID

			threads << Thread.new do
				repeat = true if pars1(l , pr) == -1
			end
		end
		threads.each {|thr| thr.join }

		sleep 2
		#p "repeat? #{repeat}"
		#goPars if repeat && workingProxiesLeft > 0 
	end

	def start
		setLoadedProxiesUnused
		p goPars
		#saveProxies
	end


	def parsItems doc
		group = doc.css('.breadcrumb-arrows a')	
		groups = []
		group.each do |ds|
			groups << ds.text.strip
		end

		return -1 if group.count == 0

		table_rows = doc.css('tr[data-index]')
		begin
			Ilink.transaction do
				table_rows.each do |tr|
					column = 2
					item = []
					tr.css('.column').each do |tc|
						item[column] = tc.text.strip 
						column += 1	
					end
					item[0] = Site + tr.css('a#lnkMfrPartNumber')[0]['href']
					item[1] = groups.join('>')
					item[2] = Site + tr.css('.refine-prod-img')[0]['src'] unless tr.css('img')[0] == nil
					Ilink.create(url: item[0], stype: 1, body: item.join('||'))
				end		
			end
		rescue
			p 'transaction error!'
			return -1
		end
		return 1
	end

	def setProxiesUnused
		Proxy.where(used: 1, status: nil).each do |p|
			p.setUnused
		end
	end

	def setLoadedProxiesUnused
		return if $tProxies == nil
		$tProxies.each do |pr|
			pr.used = nil
		end
	end

	def setProxiesWorking
		Proxy.transaction do
			Proxy.all.each do |p|
				p.setWorking
			end
		end
	end

	def repairLinks
		Ilink.where(stype: 1).each do |l|
			item = l.body.split('||')
			item[0] = Site + item[0]
			l.url = item[0]
			l.body = item.join("||")
			l.save!
		end
	end
end
