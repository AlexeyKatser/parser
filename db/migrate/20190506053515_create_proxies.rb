class CreateProxies < ActiveRecord::Migration[5.2]
  def change
    create_table :proxies do |t|
    	t.string 		:ip
    	t.integer		:port
    	t.integer		:status
    	t.integer 	:timeUsed
    	t.integer 	:allTimeUsed
     	t.timestamps
    end
  end
end
