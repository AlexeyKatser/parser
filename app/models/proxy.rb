class Proxy < ApplicationRecord

	#attr_accessor :ip, :port, :status, :timeUsed, :allTimeUsed

	validates :ip, presence: true
	validates :port, presence: true
	validates :ip, uniqueness: true
	#validates :ip, numericality: { only_integer: true }
	validates :ip, format: {with: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/, message: 'wrong format'}

	def setUsed
		#puts "#{self.id}, #{self.ip}, #{:ip}"
		self.status = 1
		self.save!
	end

	def used
		self.status
	end

 	def get_ip
 		self.ip
 	end

 	def get_port
 		self.port
 	end
end
