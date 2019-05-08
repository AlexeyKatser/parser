class CreateIlinks < ActiveRecord::Migration[5.2]
  def change
    create_table :ilinks do |t|
    	t.string		:url, index: { unique: true }
    	t.integer		:stype
    	t.boolean 		:done

      	t.timestamps
    end
  end
end
