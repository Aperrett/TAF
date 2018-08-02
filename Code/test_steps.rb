# frozen_string_literal: true

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
    value1 = $test_value
    value2 = $test_value2
    locate1 = $locate
    locate2 = $locate2
    runtest = $skipTestCase
    teststepfunc = $testStepFunction

    case teststepfunc
    when 'open_url'
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.open_url(value1) if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'portal_login'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = CustomFuncs.portal_login(value1) if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'admin_portal_login'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = CustomFuncs.portal_admin_login if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'sint_login'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = CustomFuncs.sint_login if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'ping_test'
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.ping_test(value1) if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_url'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.check_url(value1) if runtest == false
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'write_to_editor'
      # one parameter: iframe, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.write_to_editor(value1, locate1, value2)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'capture_alert'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.capture_alert if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'click_button'
      # one parameter: button
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.click_button(value1, locate1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'select_dropdown'
      # two parameters: dropdown, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.select_dropdown(value1, value2, locate1, locate2)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'list_all_dropdown_values'
      # one parameter: dropdown
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.list_dropdowns(value1, locate1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'write_box_data'
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.write_text(value1, value2, locate1)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_box_data'
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.check_boxdata(value1, value2, locate1)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_screen_data'
      # one parameters: the text to search for on screen
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.check_screendata(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_browser_title'
      # one parameters: text to check browser title.
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.check_title(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_log_file'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.check_log_file(value1, value2, locate1)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'ipause'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.ipause(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'execute_system_command'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.sys_command(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_box'
      # one parameter: checkbox
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.check_box(value1, locate1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'radio_button'
      # one parameter: radio
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = WebFuncs.radio_button(value1, value2, locate1, locate2)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_refresh'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.browser_refresh if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_back'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.browser_back if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_forward'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.browser_forward if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_quit'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.browser_quit if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'insert_value_config'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      if runtest == false
        test_pass = CustomFuncs.insert_value_config(value1, value2, locate1)
      end
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'open_portal_url'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = CustomFuncs.open_portal_url(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'handle_browser_window'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.handle_browser_window(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'send_special_keys'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      test_pass = WebFuncs.send_special_keys(value1) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(test_pass, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    else
      $results_file.write("Unable to match function: #{teststepfunc} \n")
      print "Unable to match function: #{teststepfunc}"
      puts ''
    end
  end
end
