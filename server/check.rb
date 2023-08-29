require 'time'
require 'json'
require "net/https"
require 'rubygems'
require 'twilio-ruby'
require 'dotenv/load'
require_relative 'alert_service'

LEVEL_1_MINUTES =  2
LEVEL_2_MINUTES =  5
LEVEL_3_MINUTES = 10
LEVEL_4_MINUTES = 30

class CheckService
  def check
    puts "Seconds from last heartbeat: #{seconds_from_last_heartbeat}"
    puts "Last alert was: #{last_alert_sent}\n\n"

    return if seconds_from_last_heartbeat.nil?

    if seconds_from_last_heartbeat    >= 60 * LEVEL_4_MINUTES
      alert! 4
    elsif seconds_from_last_heartbeat >= 60 * LEVEL_3_MINUTES
      alert! 3
    elsif seconds_from_last_heartbeat >= 60 * LEVEL_2_MINUTES
      alert! 2
    elsif seconds_from_last_heartbeat >= 60 * LEVEL_1_MINUTES
      alert! 1
    else
      puts "Router is ok"
      mark_alert_sent 0
    end
  end

  def seconds_from_last_heartbeat
    last_heartbeat = Time.parse File.open(ENV['HEARTBEAT_FILE_PATH']).read

    diff = Time.now.utc.to_f - last_heartbeat.to_f
    diff.to_i
  rescue
    puts 'Warning: no heartbeat yet'
    nil
  end

  def already_sent?(level)
    last_alert_sent.to_s == level.to_s
  end

  def last_alert_sent
    File.open(ENV['COOLDOWN_FILE_PATH']).read
  rescue
    nil
  end

  def mark_alert_sent(level = 0)
    File.write(ENV['COOLDOWN_FILE_PATH'], level.to_s, mode: 'w')
  end

  def alert!(level)
    puts "Alert #{level}!\n\n"

    if already_sent? level
      puts "Already sent this level of alert, so we'll wait a little bit more\n\n"
      return
    end

    if level == 1
      AlertService.new.send_push_notification(critical: false)
    elsif level == 2
      AlertService.new.send_push_notification(critical: false)
      AlertService.new.send_sms
    elsif level == 3
      AlertService.new.send_push_notification(critical: false)
      AlertService.new.gsm_call
    else level == 4
      AlertService.new.send_push_notification(critical: true)
      AlertService.new.gsm_call
      AlertService.new.send_sms
    end

    mark_alert_sent level
  end
end

CheckService.new.check
