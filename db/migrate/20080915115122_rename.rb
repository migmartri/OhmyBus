class Rename < ActiveRecord::Migration
  def self.up
    remove_column :alerts, :line_id
    add_column :alerts, :line_label, :string
  end

  def self.down
    add_column :alerts, :line_id, :integer
    remove_column :alerts, :line_label
  end
end
