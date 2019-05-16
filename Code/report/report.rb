# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# report.rb - methods for outputting console.
module Report
  require_relative '../taf_config.rb'

  # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
  def self.current_time
    Time.new.strftime('%a %b %d %H:%M:%S %Z')
  end

  # print the test Step info to the test results file
  def self.print_test_step_header(test_file_name, test_step_idx, test_desc)
    @test_start_time = current_time
    MyLog.log.info "Test step: #{test_step_idx} : #{test_desc}"

    step = {
      'id' => test_step_idx,
      'classname' => "SuiteID: #{$testId} Test Step: #{test_step_idx} "\
      "#{test_desc}",
      'name' => test_desc,
      'file' => test_file_name
    }
    # output to console to show test step
    # puts step

    return unless test_file_name

    $testStep_xml ||= {}
    $testStep_xml[test_file_name] ||= {}
    $testStep_xml[test_file_name][test_step_idx] = step
  end

  # print the Pass / Fail status of a test to the test results file
  def self.test_pass_fail(pass_fail, test_file_name, test_step_idx)
    if pass_fail == true
      $previousTestFail = $currentTestFail
      $currentTestFail = false
      $testStepPasses += 1
      MyLog.log.info "Test #{test_step_idx} has Passed ".green
    elsif pass_fail == false
      $previousTestFail = $currentTestFail
      $currentTestFail = true
      $testStepFailures += 1
      MyLog.log.info "Test #{test_step_idx} has FAILED ".red
      failstep = {
        'message' => "SuiteID: #{$testId} Test Step: #{test_step_idx} Test has"\
         ' FAILED - Check logs',
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
      $currentTestFail = false
      $testStepNotrun += 1
      MyLog.log.info "Test #{test_step_idx} no checks performed ".blue
      skipstep = {
        'message' => "SuiteID: #{$testId} Test Step: #{test_step_idx} No"\
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
    MyLog.log.info "Test step duration: #{test_duration}"
  end

  # check if the test failure threshold has been reached for total failures
  # or consecutive failures.
  # If a certain number of consecutive tests fail then throw an exception
  def self.check_failure_threshold(test_file_name)
    consecutive_fail_threshold = 5
    if $previousTestFail && $currentTestFail
      @consecutive_test_fail += 1
    else
      @consecutive_test_fail = 0
    end

    return if @consecutive_test_fail < consecutive_fail_threshold

    # write info to stdout
    MyLog.log.warn "Terminating the current test file: #{test_file_name} as" \
      " the test failure threshold (#{$testStepFailures}) has been" \
      ' reached.'
    MyLog.log.warn '...continuing with the next test file (if there is one)'

    raise FailureThresholdExceeded,
          "#{$testStepFailures} Test Steps Failed."
  end
end
