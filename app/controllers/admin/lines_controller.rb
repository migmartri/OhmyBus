class Admin::LinesController < ApplicationController  
  before_filter :authenticate_admin
  
  def index
    respond_to do |format|
      format.html{@lines = Line.all}
      format.js{
        stop = Stop.find(params[:stop])
        render :json => stop.lines.to_json
      }
    end
  end
  
  
  def new
    @line = Line.new
  end
  
  
  def create
    @line = Line.new(params[:line])
    if @line.save
      flash[:notice] = "Linea creada"
      redirect_to admin_lines_path
    else
      flash[:error] = "Error al crear la linea"
      render :action => 'new'
    end
  end
  
  
  def edit
    @line = Line.find(params[:id])
  end
  

  
  def update
    @line = Line.find(params[:id])
    if @line.update_attributes(params[:line])
      flash[:notice] = "Linea Modificada"
      redirect_to admin_lines_path
    else
      flash[:error] = "Error al modificar la linea"
      render :action => 'edit'
    end
  end
  
  
  
  def destroy
    @line = Line.find(params[:id])
    if @line.destroy
      flash[:notice] = "Linea borrada"
    else
      flash[:error] = "Error al eliminar la linea"
    end
    redirect_to admin_lines_path
  end
end
