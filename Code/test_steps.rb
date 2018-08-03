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
  def self.process_teststeps(test_file_name, teststepindex)
    value1 = $test_value
    value2 = $test_value2
    locate1 = $locate
    locate2 = $locate2
    runtest = $skipTestCase
    teststepfunc = $testStepFunction

    # print the test step information
    Report.printTestStepHeader(test_file_name, teststepindex)
    case teststepfunc
    # call the appropriate methods
    when 'open_url'
      testfunc = WebFuncs.open_url(value1) if runtest == false

    when 'portal_login'
      testfunc = CustomFuncs.portal_login(value1) if runtest == false

    when 'ping_test'
      testfunc = WebFuncs.ping_test(value1) if runtest == false

    when 'check_url'
      testfunc = WebFuncs.check_url(value1) if runtest == false

    when 'write_to_editor'
      if runtest == false
        testfunc = WebFuncs.write_to_editor(value1, locate1, value2)
      end

    when 'capture_alert'
      testfunc = WebFuncs.capture_alert if runtest == false

    when 'click_button'
      testfunc = WebFuncs.click_button(value1, locate1) if runtest == false

    when 'select_dropdown'
      if runtest == false
        testfunc = WebFuncs.select_dropdown(value1, value2, locate1, locate2)
      end

    when 'list_all_dropdown_values'
      testfunc = WebFuncs.list_dropdowns(value1, locate1) if runtest == false

    when 'write_box_data'
      if runtest == false
        testfunc = WebFuncs.write_text(value1, value2, locate1)
      end

    when 'check_box_data'
      if runtest == false
        testfunc = WebFuncs.check_boxdata(value1, value2, locate1)
      end

    when 'check_screen_data'
      testfunc = WebFuncs.check_screendata(value1) if runtest == false

    when 'check_browser_title'
      testfunc = WebFuncs.check_title(value1) if runtest == false

    when 'check_log_file'
      if runtest == false
        testfunc = WebFuncs.check_log_file(value1, value2, locate1)
      end

    when 'ipause'
      testfunc = WebFuncs.ipause(value1) if runtest == false

    when 'execute_system_command'
      testfunc = WebFuncs.sys_command(value1) if runtest == false

    when 'check_box'
      testfunc = WebFuncs.check_box(value1, locate1) if runtest == false

    when 'radio_button'
      if runtest == false
        testfunc = WebFuncs.radio_button(value1, value2, locate1, locate2)
      end

    when 'browser_refresh'
      testfunc = WebFuncs.browser_refresh if runtest == false

    when 'browser_back'
      testfunc = WebFuncs.browser_back if runtest == false

    when 'browser_forward'
      testfunc = WebFuncs.browser_forward if runtest == false

    when 'browser_quit'
      testfunc = WebFuncs.browser_quit if runtest == false

    when 'insert_value_config'
      if runtest == false
        testfunc = CustomFuncs.insert_value_config(value1, value2, locate1)
      end

    when 'open_portal_url'
      testfunc = CustomFuncs.open_portal_url(value1) if runtest == false

    when 'handle_browser_window'
      testfunc = WebFuncs.handle_browser_window(value1) if runtest == false

    when 'send_special_keys'
      testfunc = WebFuncs.send_special_keys(value1) if runtest == false
    end

    # print the test step result information
    Report.testPassFail(testfunc, test_file_name, teststepindex)
    Report.checkFailureThreshold(test_file_name)
  rescue StandardError
    $results_file.write("Unable to match function: #{teststepfunc} \n")
    print "Unable to match function: #{teststepfunc}"
    puts ''
  end
end
