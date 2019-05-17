class ProxiesController < ApplicationController

	#before_action :set_proxy, only: [:edit] 

	def create
		@new_proxy = Proxy.new proxy_params
		@new_proxy.save
	end

	def proxy_params
		params.require(:proxy).permit(:ip, :port, :status)
	end

	def set_proxy
 		@proxy = Proxy.find(params[:id])
 	end

end
