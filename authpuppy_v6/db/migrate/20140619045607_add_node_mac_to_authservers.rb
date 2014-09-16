class AddNodeMacToAuthservers < ActiveRecord::Migration
  def change
    add_column :authservers, :node_mac, :string
  end
end
