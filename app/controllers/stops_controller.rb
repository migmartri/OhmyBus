class StopsController < ApplicationController
  before_filter :load_din_soap_driver, :only => 'show'
 
  # Este método es llamado asincronamente para que el mapa cargue la lista de paradas disponibles
  def index
    @stops = Stop.find :all, :select => "lat, lng, node, name, id"
    respond_to do |format|
      format.js{
        render :json => @stops.to_json
      }  
    end
  end  
  
  def show
    @buses = @driver_din.GetPasoParadaREG(:linea => "", :parada => params[:id], :medio => 3, :status => 0)["GetPasoParadaREGResult"]
    @buses = @buses["PasoParada"] unless @buses.nil?

    respond_to do |format|
      format.js{
        if @buses.nil?
          render :text => "[{'label': '' , 'content': \"<b>No existen actualmente autobuses que pasen por esta parada</b>\"}, {}]"
        elsif @buses.class == Array
          render :text => @buses.inject("["){|sum, elem| sum + "{'label': '#{elem['linea']}' , 'content': \"Próximo: #{elem['e1']['minutos']} min.<br/>Siguiente: #{elem['e2']['minutos']} min.<br/>\"}" + " , "} + "{}]"         
        else
          render :text => "[{'label': '#{@buses['linea']}' , 'content': \"Próximo: #{@buses['e1']['minutos']} min.<br/>Siguiente: #{@buses['e2']['minutos']} min.<br/>\"}, {}]"
        end
      }
    end
  end
end
