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
  @test_step_report_summary = []
  # output the test results summary for the current test case
  def self.test_step_summary(test_file_name, test_file_name_index)
    @test_step_report_summary[test_file_name_index] = <<~TEXT
      Test file executed: #{test_file_name}
      Browser type used: #{$browserType}
      Browser version: #{Browser.browser_version}
      There are: #{$testStepPasses} Passes
      There are: #{$testStepFailures} Failures
      There are: #{$testStepNotrun} Skipped Tests \n
    TEXT
  end

  # output the overall test results summary
  def self.print_overall_test_summary
    # output to the console

    MyLog.log.info 'Finished processing all test files -' \
      "executed via test suite: #{$testcasesFolder}"
    MyLog.log.info "Overall Test Summary: \n"
    @test_step_report_summary.each do |test_step_report_summary|
      test_step_report_summary.each_line do |line|
        MyLog.log.info(line.strip)
      end
    end

    duration = TimeDifference.between(
      $test_end_time, $test_start_time
    ).humanize || 0

    MyLog.log.info "Total Tests started at: #{$test_start_time}"
    MyLog.log.info "Total Tests finished at: #{$test_end_time}"
    MyLog.log.info "Total Tests duration: #{duration}"
    MyLog.log.info "Total Tests Passed: #{$totalTestPasses}".green
    MyLog.log.info "Total Tests Failed: #{$totalTestFailures}".red
    MyLog.log.info "Total Tests Skipped: #{$totalTestNotrun}".blue
    $totalTests = [$totalTestPasses, $totalTestFailures, $totalTestNotrun].sum
    MyLog.log.info "Total Tests: #{$totalTests}\n"
  end
end
