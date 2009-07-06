class AlertsController < ApplicationController
  
  def new
    respond_to do |format|
      format.js {
        render :update do |page|
          if params[:line_id]                                                                                        
            page[:alert].replace_html(:partial => 'shared/alert', :locals => {:line => params[:line_id], :stop => params[:stop_id]})
          end
        end
      }
    end
  end
  
  def create
    @alert = Alert.new(params[:alert])                                                      
    @alert.stop = Stop.find_by_node(@alert.stop_id)                                            
    @alert.save ? flash.now[:notice] = "SMS programado :-)" : flash.now[:error] = "Existen errores."
    
    respond_to do |format|
      format.js {
        render :update do |page|
          page[:alert].replace_html(:partial => 'shared/alert', :locals => {:line => params[:alert][:line_label], :stop => params[:alert][:stop_id]})
        end        
      }
    end
  end
end