class ChangeCurseType < ActiveRecord::Migration
  def self.up
    change_column :lines, :course, :text
  end

  def self.down
    change_column :lines, :course, :string
  end
end
