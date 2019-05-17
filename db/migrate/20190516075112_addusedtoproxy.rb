class Addusedtoproxy < ActiveRecord::Migration[5.2]
  def change
  	add_column :proxies, :used, :boolean 
  end
end
