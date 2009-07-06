# == Schema Information
# Schema version: 20080915111801
#
# Table name: lines
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)     
#  name       :string(255)     
#  course     :text            
#  created_at :datetime        
#  updated_at :datetime        
#  color      :string(255)     
#

class Line < ActiveRecord::Base
  validates_presence_of :label
  
  #Recorrido escapado para ser tratado por el js
  def escaped_course
    scaped = course.gsub("\\", "\\\\\\")
    scaped = scaped.gsub('"', "\"")
    scaped = scaped.gsub("'", "\'")
  end
  
end
