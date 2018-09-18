# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# misc_functions.rb - list of all misc functions
module MiscFunctions
  require './taf_config.rb'
  # Capture alerts status Function.
  def self.capture_alert
    Browser.b.div(class: 'alert').exist?
    alertmsg = Browser.b.div(class: 'alert').text
    Report.results.puts("Alert shown: #{alertmsg}")
    true
  rescue StandardError
    Report.results.puts('No Alert Found')
    false
  end

  # handle browser windows function.
  def self.handle_browser_window(text_check)
    Browser.b.window(title: text_check.to_s).use
    sleep 3
    Browser.b.title.eql?(text_check.to_s)
    Report.results.puts("Window title: #{text_check} is correct")
    true
  rescue StandardError
    Report.results.puts("Window not found: #{text_check}")
    false
  end

  # Ipause function
  def self.ipause(wait_time)
    sleep(wait_time.to_i)
    Report.results.puts('Wait completed for seconds: ' + wait_time.to_s)
    true
  rescue StandardError
    Report.results.puts('Wait failed for seconds: ' + wait_time.to_s)
    false
  end

  # Open URL function. - the browser object is created via the main program
  def self.open_url(url)
    Browser.open_browser
    Browser.b.goto(url)
    sleep 2
    url_nme = Browser.b.url
    if url_nme == url
      Report.results.puts("opened URL: #{url}")
      return true
    else
      Report.results.puts("URL not open: #{url} - opened #{url_nme} instead")
      return false
    end
  end

  # Ping test Function.
  def self.ping_test(url)
    while pingtest == Net::Ping::HTTP.new(url)
      pingtest.ping?
      sleep 5
      if pingtest.ping? == true
        # website alive
        Report.results.puts("pinged: #{url}")
        return true
      else
        # website not responding
        Report.results.puts("Failed to ping: #{url}")
        return false
      end
    end
  end

  def self.send_special_keys(special_key)
    Browser.b.send_keys :"#{special_key}"
    sleep 1
    Report.results.puts("Browser Sent key: :#{special_key} successfully")
    true
  rescue StandardError
    Report.results.puts("Browser Failed to Send key: :#{special_key}")
    false
  end

  # execute system_command (sys_cmd) - System command you wish to execute.
  def self.sys_command(syst_cmd)
    b_result = system syst_cmd
    if b_result == true
      Report.results.puts("Cmd has been executed sucessfully #{syst_cmd}")
      return true
    else
      Report.results.puts("Theres a problem executing command #{syst_cmd}")
      return false
    end
  end
end
