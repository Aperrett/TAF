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
  # setup the test results output file
  # results file variable
  def self.results
    results_file = @results_file
  end

  # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
  def self.current_time
    time = Time.new
    f_time = time.strftime('%a %b %d %H:%M:%S %Z')
    f_time
  end

  # print the test Step info to the test results file
  def self.print_test_step_header(test_file_name, testStepIndex)
    MyLog.log.info "Test start time: #{f_time = current_time}"
    MyLog.log.info "Test step: #{$testStep} : #{$testStepDes}"

    step = {
      'id' => $testStep,
      'classname' => 'SuiteID: ' + $testId.to_s + ' Test Step: ' + $testStep.to_s + ' ' + $testStepDes.to_s,
      'name' => $testStepDes,
      'file' => test_file_name
    }
    # output to console to show test step
    # puts step

    return unless test_file_name
    $testStep_xml ||= {}
    $testStep_xml[test_file_name] ||= {}
    $testStep_xml[test_file_name][testStepIndex] = step
  end

  # print the Pass / Fail status of a test to the test results file
  def self.test_pass_fail(passFail, test_file_name, testStepIndex)
    if passFail == true
      $previousTestFail = $currentTestFail
      $currentTestFail = false
      $testStepPasses += 1
      MyLog.log.info "Test #{$testStep} has Passed ".green
    elsif passFail == false
      $previousTestFail = $currentTestFail
      $currentTestFail = true
      $testStepFailures += 1
      MyLog.log.info "Test #{$testStep} has FAILED ".red
      failstep = {
        'message' => 'SuiteID: ' + $testId.to_s + ' Test Step: ' + $testStep.to_s + ' Test has FAILED - Check logs',
        'type' => 'FAILURE',
        'file' => test_file_name
      }
      # output to console to show test step failure
      # puts failstep

      return unless test_file_name
      $failtestStep_xml ||= {}
      $failtestStep_xml[test_file_name] ||= []
      $failtestStep_xml[test_file_name][testStepIndex] = failstep
    else
      $currentTestFail = false
      $testStepNotrun += 1
      MyLog.log.info "Test #{$testStep} no checks performed ".blue
      skipstep = {
        'message' => 'SuiteID: ' + $testId.to_s + ' Test Step: ' + $testStep.to_s + ' No checks performed - Check logs',
        'type' => 'SKIPPED',
        'file' => test_file_name
      }
      # output to console to show test step failure
      # puts skipstep

      return unless test_file_name
      $skiptestStep_xml ||= {}
      $skiptestStep_xml[test_file_name] ||= []
      $skiptestStep_xml[test_file_name][testStepIndex] = skipstep
  end
    MyLog.log.info "Test end time: #{f_time = current_time}"
  end

  # check if the test failure threshold has been reached for total failures or consecutive failures.
  # If a certain number of consecutive tests fail then throw an exception
  def self.check_failure_threshold(test_file_name, testStepIndex)
    consecutiveFailThreshold = 5
    if $previousTestFail && $currentTestFail
      @consecutiveTestFail += 1
    else
      @consecutiveTestFail = 0
    end

    if @consecutiveTestFail >= consecutiveFailThreshold
      # write info to stdout
      MyLog.log.warn "Terminating the current test case: #{test_file_name} as the test failure threshold (#{consecutiveFailThreshold}) has been reached."
      MyLog.log.warn '...continuing with the next test case (if there is one)'

      raise FailureThresholdExceeded,
            "#{consecutiveFailThreshold} Test Steps Failed."
    end
  end
end
