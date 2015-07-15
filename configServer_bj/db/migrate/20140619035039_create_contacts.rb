class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :merchant
      t.string :name
      t.string :phonenum
      t.string :email
      t.string :telephonenum
      t.string :weixin
      t.integer :access_node_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string :node_mac

      t.timestamps
    end
  end
end
