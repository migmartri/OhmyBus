class LinesController < ApplicationController
  
  #Todas las paradas
  def index
    respond_to do |format|
      format.js{
        render :json => params[:stop] ? Stop.find(params[:stop]).lines.to_json(:only => [:course, :color]) : Line.all.to_json(:only => [:course, :color])
      }
    end
  end  
  
  def show
    respond_to do |format|
      format.js{
        render :json => Line.find_by_label(params[:id]).to_json(:only => [:course, :color])
      }
    end
  end
end
