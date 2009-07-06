class Admin::AlertsController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    @alerts = Alert.paginate(:all, :order => 'created_at desc', :per_page => 10, :page => params[:page])
  end
  
  def destroy
    @alert = Alert.find(params[:id])
    if @alert.destroy
      flash[:notice] = "Alerta eliminada"
      redirect_to admin_alerts_path
    else
      flash[:error] = "Error al eliminar la alerta"
      redirect_to admin_alerts_path
    end
  end
end