class History < ActiveRecord::Base
  HISTORYTYPE = {1 => 'ha creado la parada', 2 => 'ha modificado la parada', 3 => 'ha borrado la parada'}
  
  validates_presence_of :user_id, :stop_id, :name, :type_id
  belongs_to :user
  belongs_to :stop
  attr_accessor :type
  #Existen 3 tipos de historias:
  #1 - Creación de una parada
  #2 - Actualización de una parada
  #3 - Borrado de una parada
  def type
    HISTORYTYPE[self.type_id]
  end
end
