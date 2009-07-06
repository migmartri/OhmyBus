# == Schema Information
# Schema version: 20080915111801
#
# Table name: stops
#
#  id         :integer(4)      not null, primary key
#  node       :integer(4)      
#  name       :string(255)     
#  lat        :decimal(15, 10) 
#  lng        :decimal(15, 10) 
#  created_at :datetime        
#  updated_at :datetime        
#

class Stop < ActiveRecord::Base
  attr_accessor :user_id
  has_many :alerts    
  
  validates_presence_of :node, :name, :lat, :lng
  validates_uniqueness_of :node

  after_create 'create_history(1)'
  after_update 'create_history(2)'
  after_destroy 'create_history(3)'

  protected
    def create_history(type)
      History.create(:lat => self.lat, :lng => self.lng, :user_id => self.user_id, :name => self.name, :stop_id => self.id, :type_id => type)
    end
end
