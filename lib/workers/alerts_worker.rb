class AlertsWorker < BackgrounDRb::MetaWorker
  set_worker_name :alerts_worker
  
  def send_all_sms
    wsdl_dinamica = "http://www.infobustussam.com:9001/services/dinamica.asmx?WSDL"
    @driver_din = SOAP::WSDLDriverFactory.new(wsdl_dinamica).create_rpc_driver unless Alert.send_sms.empty?
    
    Alert.send_sms.each do |alert|                           
      @buses = @driver_din.GetPasoParadaREG(:linea => alert.line_label, :parada => alert.stop.node.to_s, :medio => 3, :status => 0)["GetPasoParadaREGResult"]
      if @buses.nil?
        $gateway.send([alert.movil.to_s], "No existen autobuses para esta parada en el horario seleccionado")       
        alert.update_attribute(:send_at, Time.now)
      else
        @buses = @buses["PasoParada"].class == Array ? @buses["PasoParada"][0] : @buses["PasoParada"]
        if alert.offset == 0 || alert.offset == @buses['e1']['minutos'].to_i
          $gateway.send([alert.movil.to_s], "Linea #{alert.line_label}. Parada #{alert.stop.name}: Proximo a #{@buses['e1']['minutos']} minuto/s. Siguiente #{@buses['e2']['minutos']} minuto/s.")       
          alert.update_attribute(:send_at, Time.now)
        end
      end
      
    end
  end
end