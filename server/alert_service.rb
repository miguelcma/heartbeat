class AlertService
  def send_sms
  	puts 'Sending SMS'

    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    message = @client.messages.create(
      body: 'WARNING! Router is offline',
      from: ENV['TWILIO_FROM_NUMBER'],
      to:   ENV['TWILIO_MY_NUMBER']
    )

    puts "SMS Sent: #{message.sid}"
  end

  def gsm_call
  	puts 'Calling GSM'

    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    call = @client.calls.create(
      from: ENV['TWILIO_FROM_NUMBER'],
      to:   ENV['TWILIO_MY_NUMBER'],
      url:  ENV['TWILIO_AUDIO_URL']
    )

    puts "Called to #{call.to}"
  end

  def send_push_notification(critical: false)
  	puts "Sending #{critical ? 'critical ' : '' }push"

    url = URI.parse("https://www.pushsafer.com/api")
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({
      k: ENV['PUSH_SAFER_API_KEY'],
      t: 'WARNING',
      m: 'Router is Offline!',
      pr: (critical ? '2' : '1')
    })
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start { |http| http.request(req) }
  end
end
