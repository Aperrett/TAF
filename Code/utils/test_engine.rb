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
      begin # start of rescue block for readTestData
        # read in the test data
        testFileType = Parser.read_test_data(test_file_name)
        # if unable to read the test data, show the error and move onto the
        # next file (if there is one)
      rescue StandardError => error
        MyLog.log.warn 'Terminating the current test case: ' \
                     "#{test_file_name} #{error}"
        MyLog.log.info '...continuing with the next test case (if there is one)'
      end # of rescue block for readTestData

      # create project folders - these only need creating once per test suite
      CreateDirectories.construct_projectdirs

      # loop through the test file
      MyLog.log.info 'Not a valid XLSX File Type' if testFileType != 'XLSX'

      # get the test case start time
      $test_case_start_time = Report.current_time
      # initialise the test end time
      $test_case_end_time = Report.current_time

      begin
        test_steps = Parser.parse_test_step_data(testFileType)

        test_steps.each_with_index do |test_step, step_index|
          $testStep         = test_step[:testStep]
          $testStepDes      = test_step[:testdesc]
          screen_shot       = test_step[:screenShotData]

          # process the test step data
          TestSteps.process_test_steps(test_file_name, step_index, test_step)
          # see if screenshot required
          Browser.check_save_screenshot(screen_shot)
        end
      rescue TafError => error
        warn error
        MyLog.log.warn error
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
  end # while loop for test files
end
