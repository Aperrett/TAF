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
      Time.new.strftime('%a %b %d %H:%M:%S %Z')
    end

    # print the test Step info to the test results file
    def self.print_test_step_header(test_file_name, test_step_idx, test_desc)
      @test_start_time = current_time
      Taf::MyLog.log.info "Test step: #{test_step_idx} : #{test_desc}"

      step = { 'id' => test_step_idx,
               'classname' => "SuiteID: #{Taf::JSONParser.test_id}" \
               " Test Step: #{test_step_idx} #{test_desc}",
               'name' => test_desc,
               'file' => test_file_name }

      # output to console to show test step
      # puts step

      return unless test_file_name

      $testStep_xml ||= {}
      $testStep_xml[test_file_name] ||= {}
      $testStep_xml[test_file_name][test_step_idx] = step
    end

    # print the Pass / Fail status of a test to the test results file
    def self.test_pass_fail(pass_fail, test_file_name, test_step_idx, metrics)
      if pass_fail == true
        @current_test_fail = false
        metrics.stepPasses += 1
        Taf::MyLog.log.info "Test #{test_step_idx} has Passed ".green
      elsif pass_fail == false
        @current_test_fail = true
        metrics.stepFailures += 1
        Taf::MyLog.log.warn "Test #{test_step_idx} has FAILED ".red
        sc_file_name = Taf::Screenshot.save_screenshot(test_step_idx)
        failstep = {
          'message' => "SuiteID: #{Taf::JSONParser.test_id}" \
          " Test Step: #{test_step_idx} Test has" \
           " FAILED - Check logs, see Screenshot: #{sc_file_name}",
          'type' => 'FAILURE',
          'file' => test_file_name
        }
        # output to console to show test step failure
        # puts failstep

        return unless test_file_name

        $failtestStep_xml ||= {}
        $failtestStep_xml[test_file_name] ||= []
        $failtestStep_xml[test_file_name][test_step_idx] = failstep
      else
        @current_test_fail = false
        metrics.stepSkipped += 1
        Taf::MyLog.log.info "Test #{test_step_idx} no checks performed ".blue
        skipstep = {
          'message' => "SuiteID: #{Taf::JSONParser.test_id}" \
          " Test Step: #{test_step_idx} No" \
            ' checks performed - Check logs',
          'type' => 'SKIPPED',
          'file' => test_file_name
        }
        # output to console to show test step failure
        # puts skipstep

        return unless test_file_name

        $skiptestStep_xml ||= {}
        $skiptestStep_xml[test_file_name] ||= []
        $skiptestStep_xml[test_file_name][test_step_idx] = skipstep
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
