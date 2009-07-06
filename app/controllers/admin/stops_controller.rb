class Admin::StopsController < ApplicationController
  #before_filter :authenticate_admin
  before_filter :login_required
  before_filter :load_est_soap_driver, :only => 'show'
  
  #Información de la parada según un nodo
  def show
    @stop = @driver_est.SearchNode(:substring => params[:id])
    render :text => @stop["SearchNodeResult"]["InfoNodo"].class == Array ? @stop["SearchNodeResult"]["InfoNodo"][0]["nombre"] : @stop["SearchNodeResult"]["InfoNodo"]["nombre"]
  end
  
  def create
    @stop = Stop.new(params[:stop].merge(:user_id => current_user.id))
    respond_to do |format|
      if @stop.save
        format.js{
         notify_stop_created_updated("Parada Creada") 
        }
      else
        format.js{
          ajax_flash_message(@stop.errors, "error");
        }
      end
    end
  end
  
  def update
    @stop = Stop.find(params[:id])
    
    respond_to do |format|
      if @stop.update_attributes(params[:stop].merge(:user_id => current_user.id)) 
        format.js{
          notify_stop_created_updated("Parada Actualizada")
        }
      else
        format.js{
          ajax_flash_message(@stop.errors, "error");
        }
      end 
    end
  end
  
  
  def destroy
    @stop = Stop.find(params[:id])
    respond_to do |format|
      if @stop.destroy  
        format.js{
          notify_stop_deleted("Parada Eliminada")
        }
      else
        format.js{
          ajax_flash_message(@stop.errors, "error");
        }
      end
    end
  end
  
end
