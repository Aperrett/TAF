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
  def self.test_step_summary(test_file_name, test_file_name_index, metrics)
    @test_step_report_summary[test_file_name_index] = <<~TEXT
      Test file executed: #{test_file_name}
      Browser Type: #{CMDLine.browser_type}
      Browser Version: #{Browser.browser_version}
      There are: #{metrics.stepPasses} Passes
      There are: #{metrics.stepFailures} Failures
      There are: #{metrics.stepSkipped} Skipped Tests \n
    TEXT
  end

  # output the overall test results summary
  def self.overall_test_summary(ts_start_time, ts_end_time, total_passes,
                                total_failures, total_skipped)
    # output to the console

    MyLog.log.info 'Finished processing all test files ' \
      "from the following test folder: #{CMDLine.tests_folder}"
    MyLog.log.info "Overall Test Summary: \n"
    @test_step_report_summary.each do |test_step_report_summary|
      test_step_report_summary.each_line do |line|
        MyLog.log.info(line.strip)
      end
    end

    duration = TimeDifference.between(
      ts_end_time, ts_start_time
    ).humanize || 0

    MyLog.log.info "Total Tests started at: #{ts_start_time}"
    MyLog.log.info "Total Tests finished at: #{ts_end_time}"
    MyLog.log.info "Total Tests duration: #{duration}"
    MyLog.log.info "Total Tests Passed: #{total_passes}".green
    MyLog.log.info "Total Tests Failed: #{total_failures}".red
    MyLog.log.info "Total Tests Skipped: #{total_skipped}".blue
    total_tests = [total_passes, total_failures,
                   total_skipped].sum
    MyLog.log.info "Total Tests: #{total_tests}\n"
  end
end
