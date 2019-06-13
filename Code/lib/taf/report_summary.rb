# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # report_summary.rb - methods for writing to the test summary report file
  module ReportSummary
    # holds printable test report summary for all the executed tests
    @test_step_report_summary = []
    # output the test results summary for the current test case
    def self.test_step_summary(test_file_name, test_file_name_index, metrics)
      @test_step_report_summary[test_file_name_index] = <<~TEXT
        Test file executed: #{test_file_name}
        Browser Type: #{Taf::CMDLine.browser_type}
        Browser Version: #{Taf::Browser.browser_version}
        Browser Platform: #{Taf::Browser.browser_platform}
        There are: #{metrics.stepPasses} Passes
        There are: #{metrics.stepFailures} Failures
        There are: #{metrics.stepSkipped} Skipped Tests \n
      TEXT
    end

    # output the overall test results summary
    def self.print_test_summary
      # output to the console

      Taf::MyLog.log.info 'Finished processing all test files ' \
        "from the following test folder: #{Taf::CMDLine.tests_folder}"
      Taf::MyLog.log.info "Overall Test Summary: \n"
      @test_step_report_summary.each do |test_step_report_summary|
        test_step_report_summary.each_line do |line|
          Taf::MyLog.log.info(line.strip)
        end
      end
    end

    # output the overall test results summary
    def self.overall_test_summary(total_time, total_metrics)
      print_test_summary

      Taf::MyLog.log.info "Total Duration: #{total_time}"
      Taf::MyLog.log.info "Total Tests Passed: #{total_metrics[0]}".green
      Taf::MyLog.log.info "Total Tests Failed: #{total_metrics[1]}".red
      Taf::MyLog.log.info "Total Tests Skipped: #{total_metrics[2]}".blue
      total_tests = [total_metrics[0], total_metrics[1], total_metrics[2]].sum
      Taf::MyLog.log.info "Total Tests: #{total_tests}\n"
    end
  end
end
