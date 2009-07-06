require 'net/http'
require 'uri'

class MovistarGateway

  URL = 'https://opensms.movistar.es/aplicacionpost/loginEnvio.jsp'

  def initialize(login, password)
    @login = login.to_s
    @password = password.to_s
  end

  def send(destinations, message)
    numbers = destinations.find_all do |destination|
      destination =~ /\d+/
    end.join(';')
    return if numbers.blank?
    response = Net::HTTP.post_form(URI.parse(URL),
      {
        'TM_ACTION' => 'AUTHENTICATE',
        'TM_LOGIN' => @login,
        'TM_PASSWORD' => @password,
        'to' => numbers,
        'message' => message
      }
    )
    raise "SMS could not be sent: #{response.body}" unless response.body =~ /OK/
  end

end
