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
    Report.results.write("Alert shown: #{alertmsg} \n")
    true
  rescue StandardError
    Report.results.write('No Alert Found', "\n")
    false
  end

  # handle browser windows function.
  def self.handle_browser_window(text_check)
    Browser.b.window(title: text_check.to_s).use
    sleep 3
    Browser.b.title.eql?(text_check.to_s)
    Report.results.write("Window title: #{text_check} is correct \n")
    true
  rescue StandardError
    Report.results.write("Window not found: #{text_check} \n")
    false
  end

  # Ipause function
  def self.ipause(wait_time)
    sleep(wait_time.to_i)
    Report.results.write('Wait completed for seconds: ' + wait_time.to_s + "\n")
    true
  rescue StandardError
    Report.results.write('Wait failed for seconds: ' + wait_time.to_s + "\n")
    false
  end

  # Open URL function. - the browser object is created via the main program
  def self.open_url(url)
    Browser.open_browser
    Browser.b.goto(url)
    sleep 2
    url_nme = Browser.b.url
    if url_nme == url
      Report.results.write("opened URL: #{url} \n")
      return true
    else
      Report.results.write("URL not open: #{url} - opened #{url_nme} instead\n")
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
        Report.results.write("pinged #{url} \n")
        return true
      else
        # website not responding
        Report.results.write("Failed to ping #{url} \n")
        return false
      end
    end
  end

  def self.send_special_keys(special_key)
    Browser.b.send_keys :"#{special_key}"
    sleep 1
    Report.results.write("Browser Sent key: :#{special_key} successfully \n")
    true
  rescue StandardError
    Report.results.write("Browser Failed to Send key: :#{special_key} \n")
    false
  end

  # execute system_command (sys_cmd) - System command you wish to execute.
  def self.sys_command(syst_cmd)
    b_result = system syst_cmd
    if b_result == true
      Report.results.write("Cmd has been executed sucessfully #{syst_cmd} \n")
      return true
    else
      Report.results.write("Theres a problem executing command #{syst_cmd} \n")
      return false
    end
  end
end
