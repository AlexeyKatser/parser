require 'rubygems'
require 'mechanize'
require 'proxy.rb'

readXLProxies

a = Mechanize.new do |agent|
  #agent.user_agent_alias = 'Safari 4'
  agent.pre_connect_hooks << lambda do |agent, request|
  	request['User-Agent'] = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0'
  	request['Accept-Language'] = 'u-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3'
  	request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
  	#request['Accept-Encoding'] = 'gzip, deflate'
  	#request['Cookie'] = 'wp-settings'
  	#request['Connection'] = 'keep-alive'
  end
end
a.set_proxy('119.28.73.207',	'3128')


doc = a.get('https://ru.mouser.com/Electronic-Components/') 

#puts doc.body

#doc = a.get('https://screencountry.com')

puts doc.title
doc.css('a').map do |links|
	#puts links.to_s
	puts 'https://ru.mouser.com/' + links['href'] if links['href'].match('/.+\/_\/N-.+/')
end