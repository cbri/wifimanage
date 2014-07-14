class AddCmdNodeToAccessNodes < ActiveRecord::Migration
  def change
    add_column :access_nodes, :nodecmd_id, :integer
  end
end
