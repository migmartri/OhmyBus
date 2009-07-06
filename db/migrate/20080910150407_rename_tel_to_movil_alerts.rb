class RenameTelToMovilAlerts < ActiveRecord::Migration
  def self.up
    rename_column :alerts, :tel, :movil
  end

  def self.down
    rename_column :alerts, :movil, :tel
  end
end
