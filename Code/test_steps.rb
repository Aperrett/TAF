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
  # def self.process_test_steps(test_file_name, teststepindex)
  def self.process_test_steps(test_file_name, teststepindex,
                              test_step_function, test_value, locate,
                              test_value2, locate2, skip_test_case)

    value1 = test_value
    value2 = test_value2
    locate1 = locate
    locate2 = locate2
    runtest = skip_test_case
    teststepfunc = test_step_function

    # print the test step information
    Report.print_test_step_header(test_file_name, teststepindex)
    case teststepfunc
    # call the appropriate methods
    when 'open_url'
      func = MiscFunctions.open_url(value1) if runtest == false

    when 'login'
      func = Logins.login(value1) if runtest == false

    when 'ping_test'
      func = MiscFunctions.ping_test(value1) if runtest == false

    when 'check_url'
      func = CheckFunctions.check_url(value1) if runtest == false

    when 'write_to_editor'
      if runtest == false
        func = WriteTextFunctions.write_to_editor(value1, locate1, value2)
      end

    when 'capture_alert'
      func = MiscFunctions.capture_alert if runtest == false

    when 'click_button'
      func = ClickFunctions.click_button(value1, locate1) if runtest == false

    when 'select_dropdown'
      if runtest == false
        func = ClickFunctions.select_dropdown(value1, value2, locate1, locate2)
      end

    when 'list_all_dropdown_values'
      if runtest == false
        func = CheckFunctions.list_dropdowns(value1, locate1)
      end

    when 'write_box_data'
      if runtest == false
        func = WriteTextFunctions.write_text(value1, value2, locate1)
      end

    when 'check_box_data'
      if runtest == false
        func = CheckFunctions.check_boxdata(value1, value2, locate1)
      end

    when 'check_screen_data'
      func = CheckFunctions.check_screendata(value1) if runtest == false

    when 'check_browser_title'
      func = CheckFunctions.check_title(value1) if runtest == false

    when 'check_log_file'
      if runtest == false
        func = CheckFunctions.check_logs(value1, value2, locate1)
      end

    when 'ipause'
      func = MiscFunctions.ipause(value1) if runtest == false

    when 'execute_system_command'
      func = MiscFunctions.sys_command(value1) if runtest == false

    when 'check_box'
      func = ClickFunctions.check_box(value1, locate1) if runtest == false

    when 'radio_button'
      if runtest == false
        func = ClickFunctions.radio_button(value1, value2, locate1, locate2)
      end

    when 'browser_refresh'
      func = BrowserFunctions.browser_refresh if runtest == false

    when 'browser_back'
      func = BrowserFunctions.browser_back if runtest == false

    when 'browser_forward'
      func = BrowserFunctions.browser_forward if runtest == false

    when 'browser_quit'
      func = BrowserFunctions.browser_quit if runtest == false

    when 'insert_value_config'
      if runtest == false
        func = CustomMiscFunctions.insert_value_config(value1, value2, locate1)
      end

    when 'open_portal_url'
      func = CustomMiscFunctions.open_portal_url(value1) if runtest == false

    when 'handle_browser_window'
      if runtest == false
        func = MiscFunctions.handle_browser_window(value1)
      end

    when 'send_special_keys'
      if runtest == false
        func = MiscFunctions.send_special_keys(value1)
      end

    else
      Report.results.puts("Unable to match function: #{teststepfunc}")
      puts "Unable to match function: #{teststepfunc}"
      raise UnknownTestStep, "Unknown test step: #{teststepfunc}"
    end

    # print the test step result information
    Report.test_pass_fail(func, test_file_name, teststepindex)
    Report.check_failure_threshold(test_file_name, teststepindex)
  end
end
