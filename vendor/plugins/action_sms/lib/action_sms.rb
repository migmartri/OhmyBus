ActionMailer::Base.class_eval do

    private

    def perform_delivery_smtp_with_sms(mail)
      perform_delivery_sms(mail)
      perform_delivery_smtp_without_sms(clean_numbers_from_destinations(mail))
    end

    def perform_delivery_sendmail_with_sms(mail)
      perform_delivery_sms(mail)
      perform_delivery_sendmail_without_sms(clean_numbers_from_destinations(mail))
    end

    def perform_delivery_sms(mail)
      return unless sms_settings['gateway']
      sms_gateway.send(mail.destinations, mail.body)
    end

    def sms_gateway
      @sms_gateway ||= "#{sms_settings['gateway']}_gateway".camelize.constantize.new(sms_settings['login'], sms_settings['password'])
    end

    def sms_settings
      @sms_settings ||= YAML.load_file(RAILS_ROOT + '/config/sms.yml') rescue {}
    end

    def clean_numbers_from_destinations(mail)
      mail.to = mail.to.reject { |d| d =~ /\d+/ }
      mail
    end

    alias_method_chain :perform_delivery_smtp, :sms
    alias_method_chain :perform_delivery_sendmail, :sms

end
