# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# report.rb - methods for accessing and writing to the test report file(s)
module Report
  require './taf_config.rb'
  # setup the test results output file
  def self.open_test_report_file
    # open a new file for writing
    $log.puts("Opening Test Result file: #{$testResultFileName} \n")

    # open test results file for writing if not already open
    if !File.exist?($testResultFileName) || $testResultFileName.closed?
      @results_file = File.open($testResultFileName, 'w')
    elsif $log.puts "test results file name: #{$testResultFileName} is already open"
    end
  end

  # close_testresults_file
  def self.close_test_results_file
    # if the file is open then close it
    Report.results.close unless Report.results.closed?
  end

  # results file variable
  def self.results
    results_file = @results_file
  end

  def self.open_log_file
    # open a new file for writing
    $stdout.puts "Opening log file: #{$logFileName} \n"

    # create a new log file and set the mode as 'append'
    $log = File.open($logFileName, 'w+')
  end

  def self.close_log_file
    # if the file is open then close it
    $log.close unless $log.closed?
  end

  # print the main test header info to the test results file
  def self.print_test_header
    Report.results.puts("Project Name: #{$projectName} Project ID: #{$projectId} Sprint: #{$sprint}")
    Report.results.puts("Test ID: #{$testId} Test Description: #{$testDes}")
    Report.results.puts("Executed with browser: #{$browserType}")
    Report.results.puts("Test suite: #{$testSuiteFile}")
    Report.results.puts("Tester: #{$tester}", "\n \n")
  end

  # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
  def self.current_time
    time = Time.new
    f_time = time.strftime('%a %b %d %H:%M:%S %Z')
    f_time
  end

  # print the test Step info to the test results file
  def self.print_test_step_header(test_file_name, testStepIndex)
    Report.results.puts("\n" + "Test start time: #{f_time = current_time}")
    Report.results.puts("Test step: #{$testStep} : #{$testStepDes} \n")
    puts "\nTest start time: #{f_time = current_time}   \n"
    puts "Test step: #{$testStep} : #{$testStepDes}  "

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
      Report.results.puts("Test #{$testStep} has Passed")
      puts "Test #{$testStep} has Passed ".green
    elsif passFail == false
      $previousTestFail = $currentTestFail
      $currentTestFail = true
      $testStepFailures += 1
      Report.results.puts("Test #{$testStep} has FAILED")
      puts "Test #{$testStep} has FAILED ".red
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
      Report.results.puts("Test #{$testStep} no checks performed")
      puts "Test #{$testStep} no checks performed ".blue
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
    Report.results.puts("Test end time: #{f_time = current_time}\n")
    puts "Test end time: #{f_time = current_time} \n"
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
      Report.results.puts("\nTerminating the current test case as the test failure threshold (#{consecutiveFailThreshold} ) has been reached")

      # write info to $stderr
      $stderr.puts "Terminating the current test case: #{test_file_name} as the test failure threshold (#{consecutiveFailThreshold}) has been reached."
      $stderr.puts '...continuing with the next test case (if there is one)'

      raise FailureThresholdExceeded,
            "#{consecutiveFailThreshold} Test Steps Failed."
    end
  end
end
