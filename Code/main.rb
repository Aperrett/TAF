# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# main.rb - Framework Driver Script
module Main
  require './taf_config.rb'

  begin
    # holds list of test file names read from the input file
    test_file_names = Array.new
    $commandLineCsvFile = false

    $XmlFileNameType = '.xml'
    $CsvFileNameType = '.csv'

    # holds printable test report summary for all the executed tests
    $testStepReportSummary = Array.new
    $testStepReportSummary2 = []
    # variables to manage the failure reporting
    $testStepPasses     = 0
    $testStepFailures   = 0
    $testStepNotrun     = 0
    $totalTestPasses    = 0
    $totalTestFailures  = 0
    $totalTestNotrun  = 0
    $consecutiveFailThreshold = 5
    $previousTestFail = false
    $currentTestFail = false
    # initialised stores for the input XML and CSV test data
    $XmlDoc = ''
    $CsvDoc = ''

    begin # start of rescue block for readTestSuiteData
    # check if the test suite file name exists on the command line
    if (ARGV.length > 0)
      $testSuiteFile = ARGV[0]
    else
      # unable to open file as not supplied as command-line parameter
      $testSuiteFile = 'unknown'
      error_to_display = 'Test File has not been supplied as a command-line parameter as expected'
      raise IOError, error_to_display
    end

    # Get the test suite data
    Utils.readTestSuiteData

  # unable to read the test file then handle the error and terminate
  rescue => error
    $stderr.puts error
    $stdout.puts error
    abort
  end

    print 'There are ', $numberOfTestSpecs, ' test files to process'
    puts ''

    # process the test files to execute the tests
    TestEngine.process_testfiles

    # get the overall test end time
    $test_end_time = Report.get_time

    # output the overall test summary
    Report.printOverallTestSummary
    Report.testSummaryJunit

    # close browser after tests have completed
    $browser.quit
    rescue StandardError => e
    $browser = "No Browser Required"
    raise e
  end
end
