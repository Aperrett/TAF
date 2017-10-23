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
    begin
      test_file_name = ''

      # initialise the index for reading the list of test file names
      test_file_name_index = 0

      # get the overall test start time
      $test_start_time = Report.get_time

      # create project folders - these only need creating once per test suite
	  CreateDirectories.construct_projectdirs

      # loop through all the available test files to execute the tests
      while (test_file_name_index < $numberOfTestSpecs) do

        # execute the 'catch' block unless the failureThresholdReached exception
        # is thrown
        catch(:failureThresholdReached) do

          # get the next test spec data from the test suite doc
          Utils.parseTestSuiteData(test_file_name_index)

          # remove any unwanted end-of-line characters from the file name
		  test_file_name = $testSpecDesc.chomp

            begin # start of rescue block for readTestData
              # read in the test data
              testFileType = Utils.readTestData(test_file_name)
              # if unable to read the test data, show the error and move onto the
              # next file (if there is one)
            rescue => error
              $stderr.puts ''
              $stderr.print 'Terminating the current test case: ', test_file_name, ' ', error
              $stderr.puts ''
              $stderr.print '...continuing with the next test case (if there is one)'
              $stderr.puts ''
            else # no exception raised

                # create the project directories, returns the screenshot directory name
              begin # start of rescue block for construct_projectdirs
                # create test spec directories - these need creating once per test spec
                fullScDirName = CreateDirectories.construct_testspecdirs
                # open the log file
                Report.open_logfile
                # if an error then show the error and terminate
              rescue => error
                $stderr.puts error
                $stdout.puts error
                abort
              end

                # open the test results output file
                Report.open_testreport_file

                # print the main test header
                Report.printTestHeader

                # step through the test file
                # CSV test step data starts at row 8 of the file and iterates for the number of test steps
                # XML test step processing starts at the first test step in the file (0) and iterates for the number of test steps
                if (testFileType == 'CSV')
                  testStepIndex = 7
                  finalTestStepIndex = testStepIndex + $numberOfTestSteps
                else
                  testStepIndex = 0
                  finalTestStepIndex = $numberOfTestSteps
                end

                $results_file.write("Number of test steps: #{$numberOfTestSteps}")
                # Show in the Test result pdf file
				$PDF.text("Number of test steps: #{$numberOfTestSteps}")
                $results_file.puts ''

                # get the test case start time
		        $test_case_start_time = Report.get_time
                # initialise the test end time
		        $test_case_end_time = Report.get_time

                while (testStepIndex < finalTestStepIndex) do
                  begin
                    Utils.parseTestStepData(testFileType, testStepIndex)
                    # if an error then show the error and move onto the next test step
                  rescue => error
                    $stderr.puts error
                    $log.puts error
                  else
                    # process the test step data
                    TestSteps.processTestSteps(test_file_name)
                    # see if screenshot required
                    Utils.checkSaveScreenShot(fullScDirName)
                  end # of rescue block for parseTestStepData

                    # increment loop counter to move onto next test step
                    testStepIndex += 1

                end # while loop for test steps
            end # of rescue block for readTestData
        end # catch block

    # get the test case end time
    $test_case_end_time = Report.get_time

        # output the test results summary for the current test case,
        # pass in the test file number to save the summary against it's test file
        Report.printTestStepSummary(test_file_name, test_file_name_index + 1)

        # close the test results file for the current test case
        Report.close_testresults_file

        # close the log file
        Report.closeLogFile

        # close the browser if created
        if !$browser.nil?
          $browser.close
        end

        # increment loop counter to move onto next test file
        test_file_name_index += 1

        # record total passes and failures and reset the failure counters for
        # the test steps
        $totalTestPasses   += $testStepPasses
        $totalTestFailures += $testStepFailures
        $testStepPasses   = 0
        $testStepFailures = 0

      end # while loop for test files
    end
  end
end
