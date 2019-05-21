class Proxy < ApplicationRecord

	#attr_accessor :ip, :port, :status, :timeUsed, :allTimeUsed

	validates :ip, presence: true
	validates :port, presence: true
	validates :ip, uniqueness: true
	#validates :ip, numericality: { only_integer: true }
	validates :ip, format: {with: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/, message: 'wrong format'}

	def setUsed
		#puts "#{self.id}, #{self.ip}, #{:ip}"
		self.transaction do
			self.used = 1
			self.save!
		end
	end

	def setUnused
		self.used = nil
		self.save!
	end

 	def getIP
 		self.ip
 	end

 	def getPort
 		self.port
 	end

 	def setUnworking
 		self.status = 1
 		self.save!
 	end

 	def setWorking
 		self.status = nil
 		self.save!
 	end

 	def incDone
 		self.timeUsed = 0 if self.timeUsed == nil 
 		self.timeUsed = self.timeUsed + 1
 		self.used = nil
 		self.allTimeUsed = 0 if self.allTimeUsed == nil
 		self.allTimeUsed = self.allTimeUsed + 1
 		self.save!
 	end
end
