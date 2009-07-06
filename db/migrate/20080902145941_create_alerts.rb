class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.integer :tel
      t.datetime :start_at
      t.datetime :end_at
      t.integer :offset
      t.integer :stop_id
      t.integer :line_id

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
