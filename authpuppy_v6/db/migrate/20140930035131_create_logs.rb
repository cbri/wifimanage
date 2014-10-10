class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :log_value
      t.string :dev_id

      t.timestamps
    end
  end
end
