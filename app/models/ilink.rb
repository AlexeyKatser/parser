class Ilink < ApplicationRecord

	validates :url, uniqueness: true
	validates :url, presence: true

 	def before_save 
 		#self.url.downcase!
 	end

	def setDone
		self.done = true
		self.save!
	end

end
