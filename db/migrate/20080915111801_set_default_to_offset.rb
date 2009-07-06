class SetDefaultToOffset < ActiveRecord::Migration
  def self.up
    change_column :alerts, :offset, :integer, :default => 0
  end

  def self.down
    change_column :alerts, :offset, :integer
  end
end
