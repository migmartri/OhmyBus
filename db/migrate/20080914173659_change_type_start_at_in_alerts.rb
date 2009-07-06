class ChangeTypeStartAtInAlerts < ActiveRecord::Migration
  def self.up
    change_table :alerts do |t|
      t.change :start_at, :datetime
    end 
  end

  def self.down
  end
end
