class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :province
      t.string :city
      t.string :district
      t.string :detail
      t.integer :access_node_id

      t.timestamps
    end
  end
end
