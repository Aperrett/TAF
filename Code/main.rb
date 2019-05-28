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

  # parses the cmd line imput into the taf
  CMDLine.cmdline_input

  # get the overall test suite end time
  ts_start_time = Report.current_time

  # process the test files to execute the tests
  total_passes, total_failures, total_skipped = TestEngine.process_testfiles
  total_metrics = [total_passes, total_failures, total_skipped]
  # get the overall test suite end time
  ts_end_time = Report.current_time

  # output the overall test summary
  ReportSummary.overall_test_summary(ts_start_time, ts_end_time, total_metrics)
  JunitReport.test_summary_junit(ts_start_time, ts_end_time, total_metrics)

  # Exit status code.
  Process.exit(total_failures.zero? ? 0 : 1)
end
