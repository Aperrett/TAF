# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# main.rb - Framework Driver Script
module Main
  require_relative './taf_config.rb'

  begin
    # holds list of test file names read from the input file
    test_file_names = []

    # variables to manage the failure reporting
    $testStepPasses     = 0
    $testStepFailures   = 0
    $testStepNotrun     = 0
    $totalTestPasses    = 0
    $totalTestFailures  = 0
    $totalTestNotrun = 0
    $previousTestFail = false
    $currentTestFail = false
    # initialised stores for the input xlsx test data
    $XlsxDoc = ''

    begin
      # check if the test suite file name exists on the command line
      # allow a user to input 2 arguments in to CMD line the 2 values are:
      # Testcase Folder and Browser.
      if ARGV.length < 3
        $testcasesFolder = ARGV[0]
        $browserType = ARGV[1]
        MyLog.log.info '2 arguments are required: {Testcase folder} {Browser}'
      else
        # unable to open file as not supplied as command-line parameter
        $testcasesFolder = 'unknown'
        error_to_display = 'Test case location has not been supplied as a command-line parameter as expected'
        $browserType = 'unknown'
        error_to_display = 'Browser has not been supplied as a command-line parameter as expected'
        raise IOError, error_to_display  
      end
  # unable to read the test file then handle the error and terminate
  rescue StandardError => error
    warn error
    MyLog.log.warn error
    abort
  end

    MyLog.log.info "There are: #{Parser.test_files.size} test files to process \n"

    # process the test files to execute the tests
    TestEngine.process_testfiles

    # get the overall test end time
    $test_end_time = Report.current_time

    # output the overall test summary
    ReportSummary.print_overall_test_summary
    JunitReport.test_summary_junit

    # Exit status code.
    Process.exit($totalTestFailures.zero? ? 0 : 1 )
  end
end
