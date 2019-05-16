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
     # variables to manage the failure reporting
     $testStepPasses = 0
     $testStepFailures   = 0
     $testStepNotrun     = 0
     $totalTestPasses    = 0
     $totalTestFailures  = 0
     $totalTestNotrun = 0
     $previousTestFail = false
     $currentTestFail = false
     # parses the cmd line imput into the taf
     CMDLine.cmdline_input
   end

  # process the test files to execute the tests
  TestEngine.process_testfiles

  # get the overall test end time
  $test_end_time = Report.current_time

  # output the overall test summary
  ReportSummary.print_overall_test_summary
  JunitReport.test_summary_junit

  # Exit status code.
  Process.exit($totalTestFailures.zero? ? 0 : 1)
end
