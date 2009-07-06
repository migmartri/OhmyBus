
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  #Gemas
  config.gem "packet"
  config.gem "chronic"
  config.gem 'will_paginate'
  
  config.time_zone = "Madrid"

  config.action_controller.session = {
    :session_key => '_tussamV2_session',
    :secret      => 'd30e68308d517ac6b5c9d50a7a4f8a3828c8c7cf05a4fe85a853c243ed32fa885d8ff6c795bd878ceb53d066fccecab7c45bcbc5878fc4e3910f83bd29f6d5a0'
  }

  config.active_record.observers = :user_observer
end

#GmapsKey para http://ohmybus.flowersinspace.com
GMAPS_KEY = "ABQIAAAAVIlUh-vdSct060fkk7xG7xSN0gsR3W1cGPVW8h8vyRCFoLTv4hSEdvfR3QPrJBJFaZY0m8oPx1F5VA"
#Soap
WSDL_ESTRUCTURA = "http://www.infobustussam.com:9001/services/estructura.asmx?WSDL"
WSDL_DINAMICA = "http://www.infobustussam.com:9001/services/dinamica.asmx?WSDL"

GRID_NUM = 30

#Formato de json anterior a rails 2.1
ActiveRecord::Base.include_root_in_json = false

