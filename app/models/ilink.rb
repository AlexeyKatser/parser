class Ilink < ApplicationRecord

	validates :url, uniqueness: true
	validates :url, presence: true

 	def before_save 
 		self.url.downcase!
 	end

	def set_done
		@done = true
		Self.save
	end

end
