class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_to root_path
      flash[:notice] = "Gracias por registrarte, revisa tu correo donde te hemos enviado tu código de activación"
    else
      flash[:error]  = "Error al crear la cuenta"
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      session[:user_id] = user.id
      flash[:notice] = "Registro completado, ya puedes crear y modificar paradas"
      redirect_to admin_stops_path
    when params[:activation_code].blank?
      flash[:error] = "Codigo de activación perdido, por favor sigue la url que aparece en el email de activación"
      redirect_back_or_default('/')
    else 
      flash[:error]  = "No encontramos el usuario con ese código de activación, ¿Ya activado?"
      redirect_back_or_default('/')
    end
  end
end
