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
        if (pingtest.ping? == true)
          # website alive
          $results_file.write("pinged #{url}")
          $results_file.puts ''
          return true
        else
          # website not responding
          $results_file.write("Failed to ping #{url}")
          $results_file.puts ''
          return false
        end
    end
  end # pingTest

  # Open URL function. - the browser object is created via the main program
  def self.open_url(url)
    Utils.open_browser()
    $browser.goto(url)
    sleep 2
    url_name = $browser.url
      if (url_name == url)
        $results_file.write("opened URL: #{url}")
        $results_file.puts ''
        return true
      else
        $results_file.write("URL not open: #{url} - opened #{url_name} instead")
        $results_file.puts ''
        return false
      end
  end # openUrl

  # Check URL function.
  def self.check_url(url)
    if ($browser.url == url)
      $results_file.write("URL: #{url} is correct")
      $results_file.puts ''
      return true
    else
      $results_file.write("URL: #{url} is incorrect")
      $results_file.puts ''
      return false
    end
  end # CheckURL

  # Click button function.
  def self.click_button(button, locate)
    found_button = [
      $browser.button(:"#{locate}" => button).exist?,
      $browser.span(:"#{locate}" => button).exist?
    ]

    raise "Multiple matches" if found_button.select { |i| i }.size > 1
    index = found_button.index(true)
    return unless index
    if (index == 0)
      $browser.button(:"#{locate}" => button).wait_until_present.click
    elsif (index == 1)
      $browser.span(:"#{locate}" => button).wait_until_present.click
    end
    $results_file.write("Button: #{button} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Button: #{button} does not exist")
    $results_file.puts ''
    return false
  end # clickButton

  # Select Link Function.
  def self.select_link(link, locate)
    $browser.link(:"#{locate}" => link).exist?
    $browser.link(:"#{locate}" => link).wait_until_present.click
    $results_file.write("Link: #{link} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Link: #{link} does not exist")
    $results_file.puts ''
    return false
  end # select link.

  # Select Image Function.
  def self.select_image(image, locate)
    $browser.image(:"#{locate}" => image).exist?
    $browser.image(:"#{locate}" => image).wait_until_present.click
    $results_file.write("Image: #{image} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Image: #{image} does not exist")
    $results_file.puts ''
    return false
  end # select image.

  # Select Item Function.
  def self.select_item(item, locate)
    $browser.a(:"#{locate}" => item).exist?
    $browser.a(:"#{locate}" => item).wait_until_present.click
    $results_file.write("Item: #{item} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Item: #{item} does not exist")
    $results_file.puts ''
   return false
  end # select item.

  # click on a "h<font size>" tag.
  def self.click_h_tag(item, locate)
    found_tags = [
      $browser.h1(:"#{locate}" => item).exist?,
      $browser.h2(:"#{locate}" => item).exist?,
      $browser.h3(:"#{locate}" => item).exist?,
      $browser.h4(:"#{locate}" => item).exist?,
      $browser.h5(:"#{locate}" => item).exist?,
      $browser.h6(:"#{locate}" => item).exist?
    ]

    raise "Multiple matches" if found_tags.select { |i| i }.size > 1
    index = found_tags.index(true)
    return unless index
    $browser.send("h#{index + 1}", :"#{locate}" => item).click
    $results_file.write("Item: #{item} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Item: #{item} does not exist")
    $results_file.puts ''
    return false
  end # click on a "h<font size>" tag

  # Capture alerts status Function.
  def self.capture_alert
    $browser.div(:class => "alert").exist?
    alertmsg = $browser.div(:class => "alert").text
    $results_file.write("Alert shown: #{alertmsg}")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("No Alert Found")
    $results_file.puts ''
    return false
  end # capture alerts status

  # write to editor Function.
  def self.write_to_editor(iframe, locate, value)
    $browser.iframe(:"#{locate}" => iframe).wait_until_present
    $browser.iframe(:"#{locate}" => iframe).send_keys value
    $results_file.write("Editor box: #{iframe} has correct value: #{value}")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Editor box: #{iframe} has wrong value: #{value}")
    $results_file.puts ''
    return false
  rescue
    $results_file.write("Editor box: #{iframe} does not exist")
    $results_file.puts ''
    return false
  end # write to editor.

  # Write text box function.
  def self.write_text(box, value, locate)
    # two parameters: box, value
    found_box = [
      $browser.textarea(:"#{locate}" => box).exist?,
      $browser.text_field(:"#{locate}" => box).exist?
    ]

    raise "Multiple matches" if found_box.select { |i| i }.size > 1
    index = found_box.index(true)
    return unless index
    if (index == 0)
      $browser.textarea(:"#{locate}" => box).wait_until_present.set value
      ($browser.textarea(:"#{locate}" => box).value == value)
    elsif (index == 1)
      $browser.text_field(:"#{locate}" => box).wait_until_present.set value
      ($browser.text_field(:"#{locate}" => box).value == value)
    end
    $results_file.write("Text box: #{box} has correct value: #{value}")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Text box: #{box} has the incorrect value: #{value}")
    $results_file.puts ''
    return false
  rescue
    $results_file.write("Text box: #{box} does not exist")
    $results_file.puts ''
    return false
  end # writeBoxData

  # Checkbox function.
  def self.check_box(checkbox, locate)
    $browser.checkbox(:"#{locate}" => checkbox).wait_until_present.click
    $results_file.write("Check box: #{checkbox} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Check box: #{checkbox} does not exist")
    $results_file.puts ''
    return false
  end # checkBox

  # Checkbox data function.
  def self.check_boxdata(box, value, locate)
    # two parameters: box, value
    found_box = [
      $browser.textarea(:"#{locate}" => box).exist?,
      $browser.text_field(:"#{locate}" => box).exist?
    ]
    
    raise "Multiple matches" if found_box.select { |i| i }.size > 1
    index = found_box.index(true)
    return unless index
    if (index == 0)
      $browser.textarea(:"#{locate}" => box).wait_until_present
      ($browser.textarea(:"#{locate}" => box).value == value)
    elsif (index == 1)
      $browser.text_field(:"#{locate}" => box).wait_until_present
      ($browser.text_field(:"#{locate}" => box).value == value)
    end
    $results_file.write("Text box: #{box} has the correct value: #{value}")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Text box: #{box} has the incorrect value: #{value}")
    $results_file.puts ''
    return false
  rescue
    $results_file.write("Text box: #{box} does not exist")
    $results_file.puts ''
    return false
  end # checkBoxData

  # Radio button function.
  def self.radio_button(radio, value, locate, locate2)
    $browser.radio(:"#{locate}" => radio).wait_until_present
    $browser.radio(:"#{locate}" => radio, :"#{locate2}" => value).set
    $results_file.write("Radio button: #{radio} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Radio button: #{radio} does not exist")
    $results_file.puts ''
    return false
  end # radioButton

  # Ipause function
  def self.ipause(wait_time)
    sleep(wait_time.to_i)
    $results_file.write('Sleep completed for seconds: ' + wait_time.to_s)
    $results_file.puts ''
    return true
  rescue
    $results_file.write('Sleep failed for seconds: ' + wait_time.to_s)
    $results_file.puts ''
    return false
  end # ipause function.

  # Select Dropdown function.
  def self.select_dropdown(dropdown, value, locate, locate2)
    # two parameters: dropdown, value
    $browser.select_list(:"#{locate}" => dropdown).wait_until_present
    $browser.select_list(:"#{locate}" => dropdown).option(:"#{locate2}" => value).select
    $results_file.write("Dropdown item: #{value} has been selected")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Dropdown item: #{value} has NOT been selected")
    $results_file.puts ''
    return false
  rescue
    $results_file.write("the dropdown: #{dropdown} does not exist")
    $results_file.puts ''
    return false
  end # SelectDropdown

  # check screen data function.
  def self.check_screendata(text_check)
    # one parameter: text value to check if text is displayed on page.
    sleep 2 
    if ($browser.text.include?(text_check))
      $results_file.write("found text: #{text_check}")
      $results_file.puts ''
      return true
    else
      $results_file.write("NOT found: #{text_check}")
      $results_file.puts ''
      return false
    end
  end # checkScreenData

  # check browser title function.
  def self.check_title(text_check)
    sleep 2
    # one parameter: text value to check if browser title is correct.
    if ($browser.title.eql?(text_check))
      $results_file.write("Browser title: #{text_check}")
      $results_file.puts ''
      return true
    else
      $results_file.write("Title not found: #{text_check}")
      $results_file.puts ''
      return false
    end
  end # check browser title

  # list All Dropdown Values function.
  def self.list_dropdowns(dropdown, locate)
    # print out the available dropdown selections
    $browser.element(:"#{locate}" => dropdown).wait_until_present
    $browser.select_list(:"#{locate}" => dropdown).options.each do |i|
      $results_file.puts "  #{i.text}"
    $results_file.write("List of dropdowns for #{dropdown} are: #{i.text}")
    $results_file.puts ''
    $results_file.puts ''
    return true
    end
  rescue
    $results_file.write("the dropdown: #{dropdown} does not exist")
    $results_file.puts ''
    return false
  end # listAllDropdownValues

  # execute system_command (sys_cmd) - System command you wish to execute.
  def self.sys_command(syst_cmd)
    b_result = system syst_cmd
    if b_result == true
      $results_file.write("Command has been executed sucessfully #{syst_cmd}")
      $results_file.puts ''
      return true
    else
      $results_file.write("Theres a problem executing command #{syst_cmd}")
      $results_file.puts ''
      return false
    end
  end # end of system_command function

  # checkLogFile(text, file, output) - Pipe evidence to a file
  def self.check_log_file(text, file, output)
    blog_result = system 'egrep -i ' + text + ' ' + file + ' > ' + output
    if blog_result == true
      $results_file.write('Data has matched: ' + text + ' in LogFile: ' + file)
      $results_file.puts ''
      return true
    else
      $results_file.write('Problem finding ' + text + ' in LogFile: ' + file)
      $results_file.puts ''
      return false
    end
  end # end of check log file.

  # Browser Refresh function.
  def self.browser_refresh
    $browser.refresh
    $results_file.write('The Browser has been refreshed')
    $results_file.puts ''
    return true
  rescue
    $results_file.write('The Browser failed to refresh')
    $results_file.puts ''
    return false
  end # browser refresh

  # Browser Back function.
  def self.browser_back
    $browser.back
    $results_file.write('Browser navigated back')
    $results_file.puts ''
    return true
  rescue
    $results_file.write('Browser failed to navigate back')
    $results_file.puts ''
    return false
  end # browser back

  # Browser Forward function.
  def self.browser_forward
    $browser.forward
    $results_file.write('Browser navigated forward')
    $results_file.puts ''
    return true
  rescue
    $results_file.write('Browser failed to navigate forward')
    $results_file.puts ''
    return false
  end # browser forward

  # Browser Quit function.
  def self.browser_quit
    $browser.quit
    $results_file.write('Browser has closed successfully')
    $results_file.puts ''
    return true
  rescue
    $results_file.write('Browser has failed to close')
    $results_file.puts ''
    return false
  end # browser close

  # handle browser windows function.
  def self.handle_browser_window(text_check)
        $browser.window(title: "#{text_check}").use
        sleep 3
        ($browser.title.eql?("#{text_check}"))
        $results_file.write("Window title: #{text_check} is correct")
        $results_file.puts ''
        return true
  rescue
        #$browser.quit
        $results_file.write("Window not found: #{text_check}")
        $results_file.puts ''
        return false 
  end # handle browser windows function. 

  # Send Special keys.
  def self.send_special_keys(special_key)
    $browser.send_keys :"#{special_key}"
    $results_file.write("Browser Sent key: :#{special_key} successfully")
    $results_file.puts ''
    return true
  rescue
    $results_file.write("Browser Failed to Send key: :#{special_key}")
    $results_file.puts ''
    return false
  end # browser back
end	# module web_functions
