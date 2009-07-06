class AddLinesStops < ActiveRecord::Migration
  def self.up
    create_table :lines_stops, :id => false do |t|
      t.integer :line_id, :stop_id
    end
  end

  def self.down
    remove_column :lines_stops
  end
end
