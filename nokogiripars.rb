require 'nokogiri'

def nokogiriPars
	page = Nokogiri::HTML(open("d:\\sites\\FPGA - Field Programmable Gate Array _ Mouser Europe.html")) 

	group = page.css('.breadcrumb-arrows a')	
	groups = []
	group.each do |ds|
		groups << ds.text.strip
		#puts ds.text
	end

	items = []

	table_rows = page.css('tr[data-index]')
	table_rows.each do |tr|
		column = 2
		item = []
		tr.css('.column').each do |tc|
			item[column] = tc.text.strip 
			column += 1
			
		end
		item[0] = tr.css('a#lnkMfrPartNumber')[0]['href']
		item[1] = groups.join('>')
		puts item[2] = tr.css('.refine-prod-img')[0]['src'] unless tr.css('img')[0] == nil
		items.push item
	end
	#puts items[1].join('||')
end

def parsLinks
	page = Nokogiri::HTML(open("d:\\sites\\FPGA - Field Programmable Gate Array _ Mouser Europe.html")) 

	all_links = page.css('a')
	puts all_links.count

	all_links.each do |links|
		puts links['href'] if links['href'] != nil && links['href'].match('/.+\/_\/N-.+/') 	
	end
end

nokogiriPars