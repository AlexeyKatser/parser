require 'rubyXL'

class Proxy
	attr_accessor :port,  :ip
	def initialize(ip, port)
		@port = port
		@ip = ip
	end
	def setUsed
		@used = true
	end
	def used
		@used
	end
end

@proxy = []

def readXLProxies
	workbook = RubyXL::Parser.parse 'proxy.xlsx'
	worksheet = workbook.worksheets[0]
	worksheet.each do |row|
		row_cells = row.cells.map{ |cell| cell.value }
		@proxy << Proxy.new(row_cells[0], row_cells[1])
	end
end

readXLProxies

@proxy.each {|v| puts " #{v.ip}:#{v.port}"}