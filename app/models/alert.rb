# == Schema Information
# Schema version: 20080915111801
#
# Table name: alerts
#
#  id          :integer(4)      not null, primary key
#  movil       :integer(4)      
#  start_at    :datetime        
#  offset      :integer(4)      default(0)
#  stop_id     :integer(4)      
#  line_id     :integer(4)      
#  created_at  :datetime        
#  updated_at  :datetime        
#  periodicall :boolean(1)      
#  send_at     :date            
#

class Alert < ActiveRecord::Base
  attr_accessor :in_time
  belongs_to :stop
  
  validates_presence_of :movil, :message => 'no puede ser blanco'
  validates_presence_of :offset, :if => lambda {|record| record.in_time == "yes"}
  validates_numericality_of :offset, :movil, :greater_than_or_equal_to => 0, :message => 'El margen de llegada del autobus debe ser mayor que cero'
  
  def validate
    errors.add(:start_at, "debe ser superior a la actual") if self.start_at.strftime("%H/%M") <= Time.now.in_time_zone.strftime("%H/%M")
  end
  
  def self.send_sms
    Alert.find(:all, :conditions => ['send_at IS NULL AND start_at <= ?', Time.now.in_time_zone])
  end
end
