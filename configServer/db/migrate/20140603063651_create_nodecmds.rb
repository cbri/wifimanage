class CreateNodecmds < ActiveRecord::Migration
  def change
    create_table :nodecmds do |t|
      t.string :cmdline

      t.timestamps
    end
  end
end
