class Addbodytoilinks < ActiveRecord::Migration[5.2]
  def change
  		add_column :ilinks, :body, :string 
  end
end
