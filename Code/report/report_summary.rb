# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# report_summary.rb - methods for writing to the test summary report file
module ReportSummary
  require_relative '../taf_config.rb'
  # holds printable test report summary for all the executed tests
  @testStepReportSummary = []
  # output the test results summary for the current test case
  def self.test_step_summary(test_file_name, test_file_name_index)
    # construct the test step report summary
    @testStepReportSummary[test_file_name_index] = 'Test file:', test_file_name,\
    "\n" 'Browser type:', $browserType, \
    "\n" 'Browser version:', Browser.browser_version.to_s, \
    "\n" 'Environment:', $env_type, \
    "\n" 'Started at:', $test_case_start_time, \
    "\n" 'Finished at:', $test_case_end_time, \
    "\n" 'There are:', $testStepPasses, 'Passes' \
    "\n" 'There are:', $testStepFailures, 'Failures' \
    "\n" 'There are:', $testStepNotrun, 'Skipped Tests' "\n"
    # ... and save in a format that is printable
    @testStepReportSummary[test_file_name_index] = @testStepReportSummary[test_file_name_index].join(' ')
  end

  # output the overall test results summary
  def self.print_overall_test_summary
    # output to the console

    MyLog.log.info "Finished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester}"
    MyLog.log.info "Overall Test Summary:"
    @testStepReportSummary.each do |testStepReportSummary|
      MyLog.log.info  testStepReportSummary
    end

    MyLog.log.info "Total Tests started at: #{$test_start_time}"
    MyLog.log.info "Total Tests finished at: #{$test_end_time}"
    MyLog.log.info ('Total Tests duration: ' + TimeDifference.between($test_end_time, $test_start_time).humanize)
    MyLog.log.info "Total Tests Passed: #{$totalTestPasses}".green
    MyLog.log.info "Total Tests Failed: #{$totalTestFailures}".red
    MyLog.log.info "Total Tests Skipped: #{$totalTestNotrun}".blue
    $totalTests = [$totalTestPasses, $totalTestFailures, $totalTestNotrun].sum
    MyLog.log.info "Total Tests: #{$totalTests}\n"

    # output to the suite summary file

    # open the suite summary file for writing if not already open
    if !File.exist?($testSuiteSummaryFileName) || $testSuiteSummaryFileName.closed?
      testSuiteSummaryFile = File.open($testSuiteSummaryFileName, 'w')
      MyLog.log.info"Test Suite Summary file located at:"
      MyLog.log.info "#{$testSuiteSummaryFileName}\n"
    elsif MyLog.log.warn "test suite summary file name: #{$testSuiteSummarylFileName} is already open"
    end

    testSuiteSummaryFile.puts "Finished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester} \n"
    testSuiteSummaryFile.puts "\nOverall Test Summary:"
    @testStepReportSummary.each do |testStepReportSummary|
      testSuiteSummaryFile.puts testStepReportSummary
    end
    testSuiteSummaryFile.puts("\nTotal Tests started at: #{$test_start_time}")
    testSuiteSummaryFile.puts("Total Tests finished at: #{$test_end_time}")
    testSuiteSummaryFile.puts('Total Tests duration: ' + TimeDifference.between($test_end_time, $test_start_time).humanize)
    testSuiteSummaryFile.puts("Total Tests Passed: #{$totalTestPasses}")
    testSuiteSummaryFile.puts("Total Tests Failed: #{$totalTestFailures}")
    testSuiteSummaryFile.puts("Total Tests Skipped: #{$totalTestNotrun}")
    testSuiteSummaryFile.puts("Total Tests: #{$totalTests} \n")

    # if the file is open then close it
    testSuiteSummaryFile.close unless testSuiteSummaryFile.closed?
  end
end
