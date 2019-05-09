# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# test_engine.rb - controls the iteration through the test suite and specs
module TestEngine
  require_relative '../taf_config.rb'

  # process the test files to execute the tests
  def self.process_testfiles
    # get the overall test start time
    $test_start_time = Report.current_time

    # loop through all the available test files to execute the tests
    Parser.test_files.each_with_index do |test_file_name, test_file_index|
      begin
        # read in the test data
        tests = Parser.read_test_data(test_file_name)
        # if unable to read the test data, show the error and move onto the
        # next file (if there is one)
      rescue StandardError => e
        MyLog.log.warn 'Terminating the current test spec: ' \
                     "#{test_file_name} #{e}"
        MyLog.log.info '...continuing with the next test file (if there is one)'
      end

      # create project folders - these only need creating once per test suite
      CreateDirectories.construct_projectdirs

      # get the test case start time
      $test_case_start_time = Report.current_time
      # initialise the test end time
      $test_case_end_time = Report.current_time

      begin
        tests['steps'].each_with_index do |test_step, test_step_idx|
          test_step_idx += 1

          parsed_steps = Parser.parse_test_step_data(test_step)

          # process the test step data
          TestSteps.process_test_steps(test_file_name, test_step_idx,
                                       parsed_steps)
          # see if screenshot required
          Screenshot.save_screenshot(parsed_steps[:screenShotData],
                                     test_step_idx)
        end
      rescue TafError => e
        warn e
        MyLog.log.warn e
      end

      # get the test case end time
      $test_case_end_time = Report.current_time

      # output the test results summary for the current test case,
      # pass in the test file number to save the summary against it's testfile
      ReportSummary.test_step_summary(test_file_name, test_file_index)
      JunitReport.test_step_summary_xml(test_file_name, test_file_index)

      # close the browser if created
      Browser.b.quit

      # record total passes and failures and reset the failure counters for
      # the test steps
      $totalTestPasses   += $testStepPasses
      $totalTestFailures += $testStepFailures
      $totalTestNotrun   += $testStepNotrun
      $testStepPasses   = 0
      $testStepFailures = 0
      $testStepNotrun   = 0
    end
  end
end
