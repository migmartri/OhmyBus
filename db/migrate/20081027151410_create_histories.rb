class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :stop_id, :null => false
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string :name
      t.integer :user_id, :type_id, :null => false

      t.timestamps
    end
    @user = User.create(:login => 'admin', :password => '123456', :password_confirmation => '123456', :email => 'admin@example.com')
    Stop.all.each do |s|
      History.create(:user_id => @user.id, :stop_id => s.id, :name => s.name, :lat => s.lat, :lng => s.lng, :type => 2) 
    end
  end

  def self.down
    drop_table :histories
  end
end
