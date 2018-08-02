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
    runtest = $skipTestCase
    case $testStepFunction 
    when 'open_url'
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.open_url($test_value) if runtest == false
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'portal_login'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = CustomFuncs.portal_login($test_value) if runtest == false
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'ping_test'
      # one parameter: URL
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.ping_test($test_value) if runtest == false
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_url'
      # one parameter: URL
      # url = $test_value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_url($test_value) if runtest == false
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'write_to_editor'
      # one parameter: iframe, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.write_to_editor($test_value, $locate, $test_value2) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'capture_alert'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.capture_alert if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'click_button'
      # one parameter: button
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.click_button($test_value, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'select_dropdown'
      # two parameters: dropdown, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.select_dropdown($test_value, $test_value2, $locate, $locate2) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'list_all_dropdown_values'
      # one parameter: dropdown
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.list_dropdowns($test_value, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'write_box_data'
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.write_text($test_value, $test_value2, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_box_data'
      # two parameters: Box, value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_boxdata($test_value, $test_value2, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_screen_data'
      # one parameters: the text to search for on screen
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_screendata($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_browser_title'
      # one parameters: text to check browser title.
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_title($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_log_file'
      text = $test_value
      file = $test_value2
      output = $test_value3
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_log_file(text, file, output) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'ipause'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.ipause($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'execute_system_command'
      # one parameter: syst_Command
      syst_Command = $test_value
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.sys_command(syst_Command) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'check_box'
      # one parameter: checkbox
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.check_box($test_value, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'radio_button'
      # one parameter: radio
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.radio_button($test_value, $test_value2, $locate, $locate2) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_refresh'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.browser_refresh if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_back'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.browser_back if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_forward'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.browser_forward if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'browser_quit'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.browser_quit if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'insert_value_config'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = CustomFuncs.insert_value_config($test_value, $test_value2, $locate) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'open_portal_url'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = CustomFuncs.open_portal_url($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'handle_browser_window'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.handle_browser_window($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    when 'send_special_keys'
      # print the test step information
      Report.printTestStepHeader(test_file_name, testStepIndex)
      # call the appropriate method
      testfunc = WebFuncs.send_special_keys($test_value) if runtest == false
      # Check for test Pass / Fail
      Report.testPassFail(testfunc, test_file_name, testStepIndex)
      Report.checkFailureThreshold(test_file_name)

    else
      $results_file.write("Unable to match function: #{$testStepFunction} \n")
      print "Unable to match function: #{$testStepFunction}"
      puts ''
    end
  end
end
