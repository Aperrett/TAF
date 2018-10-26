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
    @testStepReportSummary[test_file_name_index] = "\n" 'Test file:', test_file_name,\
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
    Report.results.puts ''
    Report.results.puts("Test Summary: #{@testStepReportSummary[test_file_name_index]}")
    Report.results.puts("Test end time: #{$test_case_end_time} \n")
  end

  # output the overall test results summary
  def self.print_overall_test_summary
    # output to the console

    puts "\nFinished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester}"
    puts "\nOverall Test Summary:"
    @testStepReportSummary.each do |testStepReportSummary|
      puts testStepReportSummary
    end

    puts "\nTotal Tests started at: #{$test_start_time}"
    puts "Total Tests finished at: #{$test_end_time}"
    puts ('Total Tests duration: ' + TimeDifference.between($test_end_time, $test_start_time).humanize)
    puts "Total Tests Passed: #{$totalTestPasses}".green
    puts "Total Tests Failed: #{$totalTestFailures}".red
    puts "Total Tests Skipped: #{$totalTestNotrun}".blue
    $totalTests = [$totalTestPasses, $totalTestFailures, $totalTestNotrun].sum
    puts "Total Tests: #{$totalTests}\n"

    # output to the suite summary file

    # open the suite summary file for writing if not already open
    if !File.exist?($testSuiteSummaryFileName) || $testSuiteSummaryFileName.closed?
      testSuiteSummaryFile = File.open($testSuiteSummaryFileName, 'w')
      puts "\nTest Suite Summary file located at:"
      puts "#{$testSuiteSummaryFileName}\n"
    elsif $log.puts "test suite summary file name: #{$testSuiteSummarylFileName} is already open"
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
