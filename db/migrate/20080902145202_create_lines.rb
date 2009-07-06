class CreateLines < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.string :label
      t.string :name
      t.string :course

      t.timestamps
    end
  end

  def self.down
    drop_table :lines
  end
end
