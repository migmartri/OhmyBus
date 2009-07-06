class CreateStops < ActiveRecord::Migration
  def self.up
    create_table :stops do |t|
      t.integer :node
      t.string :name
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10


      t.timestamps
    end
  end

  def self.down
    drop_table :stops
  end
end
