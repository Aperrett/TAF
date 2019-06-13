# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # report.rb - methods for outputting console.
  module Report
    # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
    def self.current_time
      require 'time'
      # Time.new.strftime('%a %b %d %H:%M:%S %Z')
      Time.new.xmlschema
    end

    # print the test Step info to the test results file
    def self.print_test_step_header(test_step_idx, test_desc)
      @test_start_time = current_time
      Taf::MyLog.log.info "Test step: #{test_step_idx} : #{test_desc}"
    end

    # print the Pass / Fail status of a test to the test results file
    def self.test_pass_fail(
      pass_fail,
      test_file_name,
      test_step_idx,
      test_step_description,
      metrics
    )
      if pass_fail
        Taf::MyLog.log.info "Test #{test_step_idx} has Passed ".green
        @current_test_fail = false
        metrics.stepPasses += 1
        Taf::TapReport.success(
          test_file_name, test_step_idx, test_step_description
        )
      elsif pass_fail == false
        Taf::MyLog.log.warn "Test #{test_step_idx} has FAILED ".red
        Taf::Screenshot.save_screenshot(test_step_idx)
        @current_test_fail = true
        metrics.stepFailures += 1
        Taf::TapReport.failure(
          test_file_name, test_step_idx, test_step_description
        )
      else
        Taf::MyLog.log.info "Test #{test_step_idx} no checks performed ".blue
        @current_test_fail = false
        metrics.stepSkipped += 1
        Taf::TapReport.skip(
          test_file_name, test_step_idx, test_step_description
        )
      end

      test_end_time = current_time
      test_duration = TimeDifference.between(
        test_end_time, @test_start_time
      ).humanize || 0
      Taf::MyLog.log.info "Test step duration: #{test_duration} \n"
    end

    # check if the test failure threshold has been reached for total failures
    # or consecutive failures.
    # If a certain number of consecutive tests fail then throw an exception

    def self.check_failure_threshold(test_file_name)
      consecutive_fail_threshold = 3
      if @current_test_fail
        @consecutive_test_fail += 1
      else
        @consecutive_test_fail = 0
      end

      return if @consecutive_test_fail < consecutive_fail_threshold

      raise Taf::FailureThresholdExceeded,
            "Terminating the current test file: #{test_file_name} as the test" \
            " failure threshold (#{@consecutive_test_fail}) has been reached."
    end
  end
end
