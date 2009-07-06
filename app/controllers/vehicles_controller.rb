class VehiclesController < ApplicationController
  before_filter :load_din_soap_driver, :only => 'index'
  
  def index
    begin
      @coches = @driver_din.GetVehiculos(:linea => params[:line])["GetVehiculosResult"]["InfoVehiculo"]   
      respond_to do |format|
        format.html{}
        format.js{
          render :text => @coches.inject("["){|sum, elem| sum + "{'xcord': #{elem['xcoord']} , 'ycord': #{elem['ycoord']}}" + " , "} + "{}]" 
        }
      end
    rescue NoMethodError 
      render :text => "[]"
    end
  end

end
