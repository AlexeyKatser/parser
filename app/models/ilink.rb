class Ilink < ApplicationRecord

	validates :url, uniqueness: true
	validates :url, presence: true

 	def before_save 
 		self.url.downcase!
 	end

	def set_done
		self.done = true
		self.save
	end

end
