# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# web_functions.rb - all web functions for the TAF.
module WebFuncs
  require './taf_config.rb'
  # Ping test Function.
  def self.ping_test(url)
    while pingtest == Net::Ping::HTTP.new(url)
      pingtest.ping?
      sleep 5
      if pingtest.ping? == true
        # website alive
        $results_file.write("pinged #{url} \n")
        return true
      else
        # website not responding
        $results_file.write("Failed to ping #{url} \n")
        return false
      end
    end
  end

  # Open URL function. - the browser object is created via the main program
  def self.open_url(url)
    Utils.open_browser
    $browser.goto(url)
    sleep 2
    url_nme = $browser.url
    if url_nme == url
      $results_file.write("opened URL: #{url} \n")
      return true
    else
      $results_file.write("URL not open: #{url} - opened #{url_nme} instead \n")
      return false
    end
  end

  # Check URL function.
  def self.check_url(url)
    if $browser.url == url
      $results_file.write("URL: #{url} is correct \n")
      true
    else
      $results_file.write("URL: #{url} is incorrect \n")
      false
    end
  end

  # Click button function.
  def self.click_button(button, locate)
    elms = %i{button span a div link image h1 h2 h3 h4}

     found_button = elms.map do |elm|
     $browser.send(elm, :"#{locate}" => button).exist?
     end.compact

    # raise 'Multiple matches' if found_button.size > 0
    # found_button.first.wait_until_present.click

    raise 'Multiple matches' if found_button.select { |i| i }.empty?
    index = found_button.index(true)
    return unless index
    if index.zero?
      $browser.button(:"#{locate}" => button).wait_until_present.click
    elsif index == 1
      $browser.span(:"#{locate}" => button).wait_until_present.click
    elsif index == 2
      $browser.a(:"#{locate}" => button).wait_until_present.click
    elsif index == 3
      $browser.div(:"#{locate}" => button).wait_until_present.click
    elsif index == 4
      $browser.link(:"#{locate}" => button).wait_until_present.click
    elsif index == 5
      $browser.image(:"#{locate}" => button).wait_until_present.click
    elsif index == 6
      $browser.h1(:"#{locate}" => button).wait_until_present.click
    elsif index == 7
      $browser.h2(:"#{locate}" => button).wait_until_present.click
    elsif index == 8
      $browser.h3(:"#{locate}" => button).wait_until_present.click
    elsif index == 9
      $browser.h4(:"#{locate}" => button).wait_until_present.click
    end     
    $results_file.write("Button: #{button} has been selected \n")
    true
  rescue StandardError
    $results_file.write("Button: #{button} does not exist \n")
    false
  end

  # Capture alerts status Function.
  def self.capture_alert
    $browser.div(class: 'alert').exist?
    alertmsg = $browser.div(class: 'alert').text
    $results_file.write("Alert shown: #{alertmsg} \n")
    true
  rescue StandardError
    $results_file.write('No Alert Found', "\n")
    false
  end

  # write to editor Function.
  def self.write_to_editor(iframe, locate, value)
    $browser.iframe(:"#{locate}" => iframe).wait_until_present
    $browser.iframe(:"#{locate}" => iframe).send_keys value
    $results_file.write("Editor box: #{iframe} has correct value: #{value} \n")
    true
  rescue StandardError
    $results_file.write("Editor box: #{iframe} has wrong value: #{value} \n")
    false
  rescue StandardError
    $results_file.write("Editor box: #{iframe} does not exist \n")
    false
  end

  # Write text box function.
  def self.write_text(box, value, locate)
    # two parameters: box, value
    found_box = [
      $browser.textarea(:"#{locate}" => box).exist?,
      $browser.text_field(:"#{locate}" => box).exist?
    ]

    raise 'Multiple matches' if found_box.select { |i| i }.empty?
    index = found_box.index(true)
    return unless index
    if index.zero?
      $browser.textarea(:"#{locate}" => box).wait_until_present.set value
      ($browser.textarea(:"#{locate}" => box).value == value)
    elsif index == 1
      $browser.text_field(:"#{locate}" => box).wait_until_present.set value
      ($browser.text_field(:"#{locate}" => box).value == value)
    end
    $results_file.write("Text box: #{box} has correct value: #{value} \n")
    true
  rescue StandardError
    $results_file.write("Text box: #{box} has the incorrect value: #{value} \n")
    false
  rescue StandardError
    $results_file.write("Text box: #{box} does not exist \n")
    false
  end

  # Checkbox function.
  def self.check_box(checkbox, locate)
    $browser.checkbox(:"#{locate}" => checkbox).wait_until_present.click
    $results_file.write("Check box: #{checkbox} has been selected \n")
    true
  rescue StandardError
    $results_file.write("Check box: #{checkbox} does not exist \n")
    false
  end

  # Checkbox data function.
  def self.check_boxdata(box, value, locate)
    # two parameters: box, value
    found_box = [
      $browser.textarea(:"#{locate}" => box).exist?,
      $browser.text_field(:"#{locate}" => box).exist?
    ]

    raise 'Multiple matches' if found_box.select { |i| i }.empty?
    index = found_box.index(true)
    return unless index
    if index.zero?
      $browser.textarea(:"#{locate}" => box).wait_until_present
      ($browser.textarea(:"#{locate}" => box).value == value)
    elsif index == 1
      $browser.text_field(:"#{locate}" => box).wait_until_present
      ($browser.text_field(:"#{locate}" => box).value == value)
    end
    $results_file.write("Text box: #{box} has the correct value: #{value} \n")
    true
  rescue StandardError
    $results_file.write("Text box: #{box} has the incorrect value: #{value} \n")
    false
  rescue StandardError
    $results_file.write("Text box: #{box} does not exist \n")
    false
  end

  # Radio button function.
  def self.radio_button(radio, value, locate, locate2)
    $browser.radio(:"#{locate}" => radio).wait_until_present
    $browser.radio(:"#{locate}" => radio, :"#{locate2}" => value).set
    $results_file.write("Radio button: #{radio} has been selected \n")
    true
  rescue StandardError
    $results_file.write("Radio button: #{radio} does not exist \n")
    false
  end

  # Ipause function
  def self.ipause(wait_time)
    sleep(wait_time.to_i)
    $results_file.write('Sleep completed for seconds: ' + wait_time.to_s + "\n")
    true
  rescue StandardError
    $results_file.write('Sleep failed for seconds: ' + wait_time.to_s + "\n")
    false
  end

  # Select Dropdown function.
  def self.select_dropdown(dropdown, value, locate, locate2)
    # two parameters: dropdown, value
    $browser.select_list(:"#{locate}" => dropdown).wait_until_present
    $browser.select_list(:"#{locate}" => dropdown).option(:"#{locate2}" => value).select
    $results_file.write("Dropdown item: #{value} has been selected \n")
    true
  rescue StandardError
    $results_file.write("Dropdown item: #{value} has NOT been selected \n")
    false
  rescue StandardError
    $results_file.write("the dropdown: #{dropdown} does not exist \n")
    false
  end

  # check screen data function.
  def self.check_screendata(text_check)
    # one parameter: text value to check if text is displayed on page.
    sleep 2
    if $browser.text.include?(text_check)
      $results_file.write("found text: #{text_check} \n")
      return true
    else
      $results_file.write("NOT found: #{text_check} \n")
      return false
    end
  end

  # check browser title function.
  def self.check_title(text_check)
    sleep 2
    # one parameter: text value to check if browser title is correct.
    if $browser.title.eql?(text_check)
      $results_file.write("Browser title: #{text_check} \n")
      return true
    else
      $results_file.write("Title not found: #{text_check} \n")
      return false
    end
  end

  # list All Dropdown Values function.
  def self.list_dropdowns(dropdown, locate)
    # print out the available dropdown selections
    $browser.element(:"#{locate}" => dropdown).wait_until_present
    $browser.select_list(:"#{locate}" => dropdown).options.each do |i|
      $results_file.write("List of dropdowns for #{dropdown} are: #{i.text} \n")
      return true
    end
  rescue StandardError
    $results_file.write("the dropdown: #{dropdown} does not exist \n")
    false
  end

  # execute system_command (sys_cmd) - System command you wish to execute.
  def self.sys_command(syst_cmd)
    b_result = system syst_cmd
    if b_result == true
      $results_file.write("Cmd has been executed sucessfully #{syst_cmd} \n")
      return true
    else
      $results_file.write("Theres a problem executing command #{syst_cmd} \n")
      return false
    end
  end

  # checkLogFile(text, file, output) - Pipe evidence to a file
  def self.check_log_file(text, file, output)
    blog_result = system 'egrep -i ' + text + ' ' + file + ' > ' + output
    if blog_result == true
      $results_file.write('Data has matched: ' + text + ' in LogFile: ' + file + "\n")
      return true
    else
      $results_file.write('Problem finding ' + text + ' in LogFile: ' + file + "\n")
      return false
    end
  end

  # Browser Refresh function.
  def self.browser_refresh
    $browser.refresh
    $results_file.write('The Browser has been refreshed', "\n")
    true
  rescue StandardError
    $results_file.write('The Browser failed to refresh', "\n")
    false
  end

  # Browser Back function.
  def self.browser_back
    $browser.back
    $results_file.write('Browser navigated back', "\n")
    true
  rescue StandardError
    $results_file.write('Browser failed to navigate back', "\n")
    false
  end

  # Browser Forward function.
  def self.browser_forward
    $browser.forward
    $results_file.write('Browser navigated forward', "\n")
    true
  rescue StandardError
    $results_file.write('Browser failed to navigate forward', "\n")
    false
  end

  # Browser Quit function.
  def self.browser_quit
    $browser.quit
    $results_file.write('Browser has closed successfully', "\n")
    true
  rescue StandardError
    $results_file.write('Browser has failed to close', "\n")
    false
  end

  # handle browser windows function.
  def self.handle_browser_window(text_check)
    $browser.window(title: text_check.to_s).use
    sleep 3
    $browser.title.eql?(text_check.to_s)
    $results_file.write("Window title: #{text_check} is correct \n")
    true
  rescue StandardError
    $results_file.write("Window not found: #{text_check} \n")
    false
  end

  # Send Special keys.
  def self.send_special_keys(special_key)
    $browser.send_keys :"#{special_key}"
    sleep 1
    $results_file.write("Browser Sent key: :#{special_key} successfully \n")
    true
  rescue StandardError
    $results_file.write("Browser Failed to Send key: :#{special_key} \n")
    false
  end
  # module web_functions
end
