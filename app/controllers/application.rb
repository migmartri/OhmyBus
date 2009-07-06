class ApplicationController < ActionController::Base  
  require "soap/wsdlDriver"    
  include AuthenticatedSystem
  
  def load_din_soap_driver 
    @driver_din ||= SOAP::WSDLDriverFactory.new(WSDL_DINAMICA).create_rpc_driver
  end
  
  def load_est_soap_driver 
    @driver_est ||= SOAP::WSDLDriverFactory.new(WSDL_ESTRUCTURA).create_rpc_driver
  end
  
  def authenticate_admin
    if RAILS_ENV == "production"
      f = YAML.load_file("#{RAILS_ROOT}/config/credentials.yml")
      #Por defecto admin - 1234 , cambialos en config/credentials.yml
      authenticate_or_request_with_http_basic do |name, pass| 
        name == f["username"] && pass == f["password"]
      end 
    end
  end
  
  #Mensajes flash
  def ajax_flash_message(mensaje, tipo)
    render :update do |page|
      case(tipo)
      when("notice")
        page["flash_notice"].innerHTML= mensaje
        page["flash_notice"].show();
        page << "Effect.Fade('flash_notice', {duration: 3.5})"
      when("error")
        page["flash_error"].innerHTML= mensaje
        page["flash_error"].show();
        page << "Effect.Fade('flash_error', {duration: 3.5})"
      end
    end
    return
  end
  
  def notify_stop_created_updated(msg)
    render :update do |page|
      page["flash_notice"].innerHTML= msg
      page["flash_notice"].show();
      page << "Effect.Fade('flash_notice', {duration: 3.5})"
      page << "notifyStopUpdated(#{@stop.to_json})"
    end
  end
  
  def notify_stop_deleted(msg)
    render :update do |page|
      page["flash_notice"].innerHTML= msg
      page["flash_notice"].show();
      page << "Effect.Fade('flash_notice', {duration: 3.5})"
      page << "map.removeOverlay(current_marker)"
    end
  end
  
end
