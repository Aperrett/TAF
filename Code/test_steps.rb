# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# test_steps.rb - process the required test step functions
module TestSteps
  require './taf_config.rb'

  # process the test step data by matching the test step functions and
  # processing the associated data accordingly
  def self.processTestSteps(test_file_name, testStepIndex)
    if ($testStepFunction == 'open_url')
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.open_url($test_value))
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'portal_login')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (CustomFuncs.portal_login)
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'admin_portal_login')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (CustomFuncs.portal_admin_login)
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'sint_login')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (CustomFuncs.sint_login)
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)  

    elsif ($testStepFunction == 'ping_test')
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.ping_test($test_value))
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_url')
      # one parameter: URL
      # url = $test_value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_url($test_value))
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'select_link')
      # one parameter: link
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.select_link($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'select_image')
      # one parameter: image
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.select_image($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'select_item')
      # one parameter: item
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.select_item($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'click_h_tag')
      # one parameter: item
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.click_h_tag($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'write_to_editor')
      # one parameter: iframe, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.write_to_editor($test_value, $locate, $test_value2))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'capture_alert')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.capture_alert)
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'click_button')
      # one parameter: button
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.click_button($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'select_dropdown')
      # two parameters: dropdown, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.select_dropdown($test_value, $test_value2, $locate, $locate2))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'list_all_dropdown_values')
      # one parameter: dropdown
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.list_dropdowns($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'write_box_data')
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.write_text($test_value, $test_value2, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_box_data')
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_boxdata($test_value, $test_value2, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_screen_data')
      # one parameters: the text to search for on screen
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_screendata($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_browser_title')
      # one parameters: text to check browser title.
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_title($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_log_file')
      text = $test_value
      file = $test_value2
      output = $test_value3
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_log_file(text, file, output))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'ipause')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.ipause($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'execute_system_command')
      # one parameter: syst_Command
      syst_Command = $test_value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.sys_command(syst_Command))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'check_box')
      # one parameter: checkbox
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.check_box($test_value, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'radio_button')
      # one parameter: radio
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.radio_button($test_value, $test_value2, $locate, $locate2))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'browser_refresh')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.browser_refresh)
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'browser_back')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.browser_back)
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'browser_forward')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.browser_forward)
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'browser_quit')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.browser_quit)
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'insert_value_config')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (CustomFuncs.insert_value_config($test_value, $test_value2, $locate))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'open_portal_url')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (CustomFuncs.open_portal_url($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    elsif ($testStepFunction == 'handle_browser_window')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.handle_browser_window($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name) 
      
    elsif ($testStepFunction == 'send_special_keys')
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = (WebFuncs.send_special_keys($test_value))
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    else
      $results_file.write("Unable to match function: #{$testStepFunction}")
      $results_file.puts ''
      print "Unable to match function: #{$testStepFunction}"
      puts ''
    end
  end # processTestSteps method
end # module
