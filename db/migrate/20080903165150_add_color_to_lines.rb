class AddColorToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :color, :string
  end

  def self.down
    remove_column :lines, :color
  end
end
