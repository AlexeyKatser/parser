require 'nokogiri'

def nokogiriPars
	page = Nokogiri::HTML(open("d:\\sites\\FPGA - Field Programmable Gate Array _ Mouser Europe.html")) 

	group = page.css('.breadcrumb-arrows')	
	groups = []
	group.css('title').each do |ds|
		groups << ds.text
	end

	items = []

	table_rows = page.css('tr[data-index]')
	row = 0
	table_rows.each do |tr|
		column = 0
		item = []
		tr.css('.column').each do |tc|
			item[column] = tc.text.strip 
			column += 1
		end
		row += 1
		items.push item
	end
	puts items[1].join('||')
end

nokogiriPars