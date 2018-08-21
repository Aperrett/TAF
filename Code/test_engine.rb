# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# test_engine.rb - controls the iteration through the test suite and specs
module TestEngine
  require './taf_config.rb'

  # process the test files to execute the tests
  def self.process_testfiles
    test_file_name = ''

    # initialise the index for reading the list of test file names
    test_file_name_index = 0

    # get the overall test start time
    $test_start_time = Report.get_time

    # create project folders - these only need creating once per test suite
    CreateDirectories.construct_projectdirs

    # loop through all the available test files to execute the tests
    while test_file_name_index < $numberOfTestSpecs
      # get the next test spec data from the test suite doc
      test_suites = Parser.parseTestSuiteData(test_file_name_index)

      test_suites.each do |test_suite|
        $testId = test_suite[:id]
        $testSpecDesc = test_suite[:specdesc]
        $env_type = test_suite[:env]
        $browserType = test_suite[:browser]

        if ARGV.length < 2
          $browserType = test_suite[:browser]
          puts "Will use the following browser from Test Suite: #{$browserType}"
          puts ''
        elsif ARGV.length < 3
          $browserType = ARGV[1]
          puts "Will use the following browser from CMD line: " + ARGV[1]
          puts ''
        else
          raise IOError, 'Unable to open browser'  
        end

        # remove any unwanted end-of-line characters from the file name
        test_file_name = $testSpecDesc

        begin # start of rescue block for readTestData
          # read in the test data
          testFileType = Parser.readTestData(test_file_name)
          # if unable to read the test data, show the error and move onto the
          # next file (if there is one)
        rescue StandardError => error
          $stderr.puts "Terminating the current test case: " \
                       "#{test_file_name} #{error}"
          $stderr.puts '...continuing with the next test case (if there is one)'
        end # of rescue block for readTestData

        # create the project directories, returns the screenshot directory name
        begin # start of rescue block for construct_projectdirs
          # create test spec directories - these need creating once per test spec
          fullScDirName = CreateDirectories.construct_testspecdirs
          # open the log file
          Report.open_logfile
          # if an error then show the error and terminate
        rescue StandardError => error
          warn error
          $stdout.puts error
          abort
        end

        # open the test results output file
        Report.open_testreport_file

        # print the main test header
        Report.printTestHeader

        # loop through the test file
        if testFileType != 'XLSX'
          puts 'Not a valid XLSX File Type'
        end

        $results_file.puts("Number of test steps: #{$numberOfTestSteps}")

        # get the test case start time
        $test_case_start_time = Report.get_time
        # initialise the test end time
        $test_case_end_time = Report.get_time

        begin
          test_steps = Parser.parseTestStepData(testFileType)

          test_steps.each_with_index do |test_step, index|
            $testStep         = test_step[:testStep]
            $testStepDes      = test_step[:testdesc]
            $testStepFunction = test_step[:testFunction]
            $test_value       = test_step[:testvalue]
            $locate           = test_step[:locate]
            $test_value2      = test_step[:testvalue2]
            $locate2          = test_step[:locate2]
            $screenShot       = test_step[:screenShotData]
            $skipTestCase     = test_step[:skipTestCase]

            # process the test step data
            TestSteps.process_teststeps(test_file_name, index)
            # see if screenshot required
            Browser.checkSaveScreenShot(fullScDirName)
          end
        rescue TafError => error
          warn error
          $log.puts error
        end

        # get the test case end time
        $test_case_end_time = Report.get_time

        # output the test results summary for the current test case,
        # pass in the test file number to save the summary against it's test file
        Report.printTestStepSummary(test_file_name, test_file_name_index)
        Report.printTestStepSummaryXml(test_file_name, test_file_name_index)

        # close the test results file for the current test case
        Report.close_testresults_file

        # close the log file
        Report.closeLogFile

        # close the browser if created
        $browser&.close

        # increment loop counter to move onto next test file
        test_file_name_index += 1

        # record total passes and failures and reset the failure counters for
        # the test steps
        $totalTestPasses   += $testStepPasses
        $totalTestFailures += $testStepFailures
        $totalTestNotrun   += $testStepNotrun
        $testStepPasses   = 0
        $testStepFailures = 0
        $testStepNotrun   = 0
      end
    end # while loop for test files
  end
end
