class IlinksController < ApplicationController

	def create
		@new_ilink = Proxy.new ilinks_params
		@new_ilink.save
	end

	def ilinks_params
		params.require(:ilink).permit(:url, :stype, :body)
	end



end
