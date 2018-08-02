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
  def self.open_testreport_file
    # open a new file for writing
    $log.write("Opening Test Result file: #{$testResultFileName}")
    $log.puts ''
    $log.puts ''

    # open test results file for writing if not already open
    if !File.exist?($testResultFileName) || $testResultFileName.closed?
      $results_file = File.open($testResultFileName, 'w')
    elsif $log.puts "test results file name: #{$testResultFileName} is already open"
    end
  end # open_testreport_file

  def self.close_testresults_file
    # if the file is open then close it
    $results_file.close unless $results_file.closed?
  end # close_testresults_file

  def self.open_logfile
    # open a new file for writing
    $stdout.print "Opening log file: #{$logFileName}"
    $stdout.puts ''
    $stdout.puts ''

    # create a new log file and set the mode as 'append'
    $log = File.open($logFileName, 'w+')
  end # open_logfile

  def self.closeLogFile
    # if the file is open then close it
    $log.close unless $log.closed?
  end # closeLogFile

  # print the main test header info to the test results file
  def self.printTestHeader
    $results_file.write("Project Name: #{$projectName} Project ID: #{$projectId} Sprint: #{$sprint} \n")
    $results_file.write("Test ID: #{$testId} Test Description: #{$testDes} \n")
    $results_file.write("Executed with browser: #{$browserType} \n")
    $results_file.write("Test suite: #{$testSuiteFile} \n")
    $results_file.write("Tester: #{$tester}", "\n \n \n")
  end # printTestHeader

  # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
  def self.get_time
    time = Time.new
    f_time = time.strftime('%a %b %d %H:%M:%S %Z')
    f_time
  end

  # print the test Step info to the test results file
  def self.printTestStepHeader(test_file_name, testStepIndex)
    $results_file.write("\n" + "Test start time: #{f_time = get_time} \n")
    $results_file.write("Test step: #{$testStep} : #{$testStepDes} \n")
    puts "Test start time: #{f_time = get_time}   \n"
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
  end # printTestStepHeader

  # print the Pass / Fail status of a test to the test results file
  def self.testPassFail(passFail, test_file_name, testStepIndex)
    if passFail == true
      $previousTestFail = $currentTestFail
      $currentTestFail = false
      $testStepPasses += 1
      $results_file.write("Test #{$testStep} has Passed, \n")
      puts "Test #{$testStep} has Passed ".green
    elsif passFail == false
      $previousTestFail = $currentTestFail
      $currentTestFail = true
      $testStepFailures += 1
      $results_file.write("Test #{$testStep} has FAILED, \n")
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
      $results_file.write("Test #{$testStep} no checks performed, ")
      puts "Test #{$testStep} no checks performed ".blue
      skipstep = {
        'message' => 'SuiteID: ' + $testId.to_s + ' Test Step: ' + $testStep.to_s + ' No checks performed - Check logs',
        'type' => 'SKIPPED',
        'file' => test_file_name
      }
      # output to console to show test step failure
      # puts failstep

      return unless test_file_name
      $skiptestStep_xml ||= {}
      $skiptestStep_xml[test_file_name] ||= []
      $skiptestStep_xml[test_file_name][testStepIndex] = skipstep
  end
    $results_file.write("Test end time: #{f_time = get_time} \n")
    puts "Test end time: #{f_time = get_time}   \n"
    puts ''
  end # testPassFail

  # check if the test failure threshold has been reached for total failures or consecutive failures.
  # If a certain number of consecutive tests fail then throw an exception
  def self.checkFailureThreshold(test_file_name)
    if $previousTestFail && $currentTestFail
      $consecutiveTestFail += 1
    else
      $consecutiveTestFail = 0
    end

    if $consecutiveTestFail >= $consecutiveFailThreshold
      $results_file.puts ''
      $results_file.write("Terminating the current test case as the test failure threshold (#{$consecutiveFailThreshold} ) has been reached \n")

      # write info to $stderr
      warn ''
      $stderr.print 'Terminating the current test case: ', test_file_name, ' as the test failure threshold (', $consecutiveFailThreshold, ') has been reached'
      warn ''
      $stderr.print '...continuing with the next test case (if there is one)'
      warn ''
      throw :failureThresholdReached
    end
  end # checkFailureThreshold

  # output the test results summary for the current test case
  def self.printTestStepSummary(test_file_name, testFileNumber)
    # construct the test step report summary
    $testStepReportSummary[testFileNumber] = "\n" 'Test file:', test_file_name,\
    "\n" 'Browser type:', $browserType, \
    "\n" 'Browser version:', Browser.browserVersion.to_s, \
    "\n" 'Environment:', $env_type, \
    "\n" 'Started at:', $test_case_start_time, \
    "\n" 'Finished at:', $test_case_end_time, \
    "\n" 'There are:', $testStepPasses, 'Passes' \
    "\n" 'There are:', $testStepFailures, 'Failures' \
    "\n" 'There are:', $testStepNotrun, 'Skipped Tests' "\n"
    # ... and save in a format that is printable
    $testStepReportSummary[testFileNumber] = $testStepReportSummary[testFileNumber].join(' ')
    $results_file.puts ''
    $results_file.write("Test Summary: #{$testStepReportSummary[testFileNumber]} \n")
    $results_file.write("Test end time: #{$test_case_end_time} \n")
  end # printTestStepSummary

  # construct the test suite header for junit
  def self.printTestStepSummaryXml(test_file_name, testFileNumber)
    $testStepReportSummary2[testFileNumber] = {
      'classname' => test_file_name,
      'name' => test_file_name,
      'assertions' => $numberOfTestSteps,
      'failures' => $testStepFailures,
      'tests' => $testStepPasses,
      'skipped' => $testStepNotrun,
      'time' => TimeDifference.between($test_case_end_time, $test_case_start_time).in_seconds
    }
  end # printTestStepSummaryXml

  # output the overall test results summary
  def self.printOverallTestSummary
    # output to the console
    puts ''
    puts "Finished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester}"
    puts ''
    puts 'Overall Test Summary:'
    $testStepReportSummary.each do |testStepReportSummary|
      puts testStepReportSummary
    end
    puts ''
    print "Total Tests started at: #{$test_start_time}"
    puts ''
    print "Total Tests finished at: #{$test_end_time}"
    puts ''
    print ('Total Tests duration: ' + TimeDifference.between($test_end_time, $test_start_time).humanize)
    puts ''
    print "Total Tests Passed: #{$totalTestPasses}".green
    puts ''
    print "Total Tests Failed: #{$totalTestFailures}".red
    puts ''
    print "Total Tests Skipped: #{$totalTestNotrun}".blue
    puts ''
    $totalTests = [$totalTestPasses, $totalTestFailures, $totalTestNotrun].sum
    print "Total Tests: #{$totalTests}"
    puts ''

    # output to the suite summary file

    # open the suite summary file for writing if not already open
    if !File.exist?($testSuiteSummaryFileName) || $testSuiteSummaryFileName.closed?
      $testSuiteSummaryFile = File.open($testSuiteSummaryFileName, 'w')
      puts ''
      puts 'Test Suite Summary file located at:'
      puts $testSuiteSummaryFileName.to_s
      puts ''
    elsif $log.puts "test suite summary file name: #{$testSuiteSummarylFileName} is already open"
    end

    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.puts "Finished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester}"
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.puts 'Overall Test Summary:'
    $testStepReportSummary.each do |testStepReportSummary|
      $testSuiteSummaryFile.puts testStepReportSummary
    end
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests started at: #{$test_start_time}")
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests finished at: #{$test_end_time}")
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write('Total Tests duration: ' + TimeDifference.between($test_end_time, $test_start_time).humanize)
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests Passed: #{$totalTestPasses}")
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests Failed: #{$totalTestFailures}")
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests Skipped: #{$totalTestNotrun}")
    $testSuiteSummaryFile.puts ''
    $testSuiteSummaryFile.write("Total Tests: #{$totalTests}")
    $testSuiteSummaryFile.puts ''

    # if the file is open then close it
    $testSuiteSummaryFile.close unless $testSuiteSummaryFile.closed?
  end # printOverallTestSummary

  def self.testSummaryJunit
    # output to XML file format for Junit for CI.
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      testsuite_attrs = {
        'classname' => $testSuiteFile.to_s,
        'name' => $testSuiteFile.to_s,
        'tests' => $totalTests.to_s,
        'failures' => $totalTestFailures.to_s,
        'timestamp' => $test_start_time.to_s,
        'skipped' => $totalTestNotrun.to_s,
        'time' => TimeDifference.between($test_end_time, $test_start_time).in_seconds
      }
      xml.testsuites(testsuite_attrs) do |testsuites|
        $testStepReportSummary2.each do |testStepReportSummary2|
          testsuites.testsuite(testStepReportSummary2) do |testsuite|
            $testStep_xml[testStepReportSummary2['name']].each do |testStepIndex, testStep_xml|
              testsuite.testcase(testStep_xml) do |testcase|
                failure = $failtestStep_xml&.[](testStepReportSummary2['name'])&.[](testStepIndex)
                skipped = $skiptestStep_xml&.[](testStepReportSummary2['name'])&.[](testStepIndex)
                testcase.failure(failure) if failure
                testcase.skipped(skipped) if skipped
              end
            end
          end
        end
      end
    end

    # output XML content to console for debug
    # puts builder.to_xml

    # open the suite summary file for writing if not already open
    if !File.exist?($TestSuiteSummaryXML) || $TestSuiteSummaryXML.closed?
      $testSuiteSummaryFile_xml = File.open($TestSuiteSummaryXML, 'w+')
      $testSuiteSummaryFile_xml.write builder.to_xml
    elsif $log.puts "test suite summary file xml name: #{$TestSuiteSummaryXML} is already open"
    end

    # if the file is open then close it
    $testSuiteSummaryFile_xml.close unless $testSuiteSummaryFile_xml.closed?
  end
end # Report module
