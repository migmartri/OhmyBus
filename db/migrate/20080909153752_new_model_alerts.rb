class NewModelAlerts < ActiveRecord::Migration
  def self.up
    change_column(:alerts, :start_at, :time)
    remove_column(:alerts, :end_at)
    add_column(:alerts, :periodicall, :boolean)
    add_column(:alerts, :send_at, :date)
  end

  def self.down
    change_column(:alerts, :start_at, :datetime)
    add_column(:alerts, :end_at, :datetime)
    remove_column(:alerts, :periodicall)
    remove_column(:alerts, :send_at)
  end
end
