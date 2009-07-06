class RemoveLinesStopsTable < ActiveRecord::Migration
  def self.up
    drop_table :lines_stops
  end

  def self.down
    create_table :lines_stops
  end
end
