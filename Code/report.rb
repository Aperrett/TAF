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
	    $PDF = Prawn::Document.new # Pdf Test Results generator.
      # open a new file for writing
      $log.write("Opening Test Result file: #{$testResultFileName}")
      $log.puts ''
      $log.puts ''

      # open test results file for writing if not already open
      if (!File.exists?($testResultFileName) || $testResultFileName.closed?)
        $results_file = File.open($testResultFileName, 'w')
      elsif
        $log.puts "test results file name: #{$testResultFileName} is already open"
      end
    end # open_testreport_file

    def self.close_testresults_file
      # if the file is open then close it
      if (!$results_file.closed?) then
        $results_file.close
      end
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
      if (!$log.closed?) then
        $log.close
      end
    end # closeLogFile

    # print the main test header info to the test results file
    def self.printTestHeader
      $results_file.write("Project Name: #{$projectName} Project ID: #{$projectId} Sprint: #{$sprint} ")
      $results_file.puts ''
      $results_file.puts ''
      $results_file.write("Test ID: #{$testId} Test Description: #{$testDes}")
      $results_file.puts ''
      $results_file.write("Executed with browser: #{$browserType}")
	    $results_file.puts ''
	    $results_file.write("Test suite: #{$testSuiteFile}")
	    $results_file.puts ''
	    $results_file.write("Tester: #{$tester}")
	    $results_file.puts ''
	    $results_file.puts ''
      $results_file.puts ''

	  # print to a PDF test result file File.
	    $PDF.text("Project Name: #{$projectName} Project ID: #{$projectId} Sprint: #{$sprint}")
      $PDF.text ' '
      $PDF.text("Test ID: #{$testId} Test Description: #{$testDes}")
      $PDF.text("Executed with browser: #{$browserType}")
	    $PDF.text("Test suite: #{$testSuiteFile}")
	    $PDF.text("Tester: #{$tester}")
	    $PDF.text ' '
    end # printTestHeader

    # get the current time in the format Day - Month - Date - Time (HH:MM:SS)
    def self.get_time
	     time = Time.new
	     f_time = time.strftime('%a %b %d %H:%M:%S %Z')
	     return f_time
    end

    # print the test Step info to the test results file
    def self.printTestStepHeader
      $results_file.write("Test start time: #{f_time = get_time()}   \n")
      $results_file.write("Test step: #{$testStep} : #{$testStepDes}  ")
	    # write the to pdf file.
	    $PDF.text("Test start time: #{f_time = get_time()}   ")
	    $PDF.text("Test step: #{$testStep} : #{$testStepDes}  ")
	    puts "Test start time: #{f_time = get_time()}   \n"
      puts "Test step: #{$testStep} : #{$testStepDes}  "
    end # printTestStepHeader

    # print the Pass / Fail status of a test to the test results file
    def self.testPassFail(passFail)
      if (passFail == true)
        $previousTestFail = $currentTestFail
        $currentTestFail = false
        $testStepPasses += 1
        $results_file.write("Test #{$testStep} has Passed, ")
		    $PDF.text "Test #{$testStep} has Passed ", :color => "00ff00" # green
	      puts "Test #{$testStep} has Passed ".green
      elsif (passFail == false)
        $previousTestFail = $currentTestFail
        $currentTestFail = true
        $testStepFailures += 1
        $results_file.write("Test #{$testStep} has FAILED, ")
		    $PDF.text "Test #{$testStep} has FAILED ", :color => "ff0000" # red
	      puts "Test #{$testStep} has FAILED ".red
      else
        $testStepNotrun += 1
        $results_file.write("Test #{$testStep} no checks performed, ")
        puts "Test #{$testStep} no checks performed ".blue
	    	$PDF.text "Test #{$testStep} no checks performed ", :color => "0000ff" # blue
    end
	    $results_file.write("Test end time: #{f_time = get_time()}   \n")
      $results_file.puts ''
		  $PDF.text("Test end time: #{f_time = get_time()}   ")
		  $PDF.text ' '
      puts "Test end time: #{f_time = get_time()}   \n"
      puts ''
    end # testPassFail

    # check if the test failure threshold has been reached for total failures or consecutive failures.
    # If a certain number of consecutive tests fail then throw an exception
    def self.checkFailureThreshold(test_file_name)
      if ($previousTestFail && $currentTestFail)
        $consecutiveTestFail += 1
      else
        $consecutiveTestFail = 0
      end

      if ($consecutiveTestFail >= $consecutiveFailThreshold) then
        $results_file.puts ''
        $results_file.write("Terminating the current test case as the test failure threshold (#{$consecutiveFailThreshold} ) has been reached")
		    $PDF.text("Terminating the current test case as the test failure threshold (#{$consecutiveFailThreshold} ) has been reached")
        $results_file.puts ''

        # write info to $stderr
        $stderr.puts ''
        $stderr.print 'Terminating the current test case: ', test_file_name, ' as the test failure threshold (', $consecutiveFailThreshold, ') has been reached'
        $stderr.puts ''
        $stderr.print '...continuing with the next test case (if there is one)'
        $stderr.puts ''
        throw :failureThresholdReached
      end
    end # checkFailureThreshold

    # output the test results summary for the current test case
    def self.printTestStepSummary(test_file_name, testFileNumber)
      # construct the test step report summary
      $testStepReportSummary[testFileNumber] = "\n" 'Test file:', test_file_name, \
      "\n" 'Browser type:', $browserType, \
      "\n" 'Browser version:', ("#{Utils.browserVersion}"), \
      "\n" 'Environment:', $env_type, \
      "\n" 'Started at:', $test_case_start_time, \
      "\n" 'Finished at:', $test_case_end_time, \
      "\n" 'There are:', $testStepPasses, 'Passes' \
      "\n" 'There are:', $testStepFailures, 'Failures' \
      "\n" 'There are:', $testStepNotrun, 'Not Runs' "\n"
      # ... and save in a format that is printable
      $testStepReportSummary[testFileNumber] = $testStepReportSummary[testFileNumber].join(' ')
      $results_file.puts ''
      $results_file.write("Test Summary: #{$testStepReportSummary[testFileNumber]}")
      $results_file.puts ''
      $results_file.write("\n Test end time: #{$test_case_end_time}")
      $results_file.puts ''

	    # print the test results summary info into the pdf test results file.
	    $PDF.text ' '
	    $PDF.text("Test Summary: #{$testStepReportSummary[testFileNumber]}")
	    $PDF.text ' '
      $PDF.text("Test end time: #{$test_case_end_time}")
      $PDF.render_file ($testResultFileNamePDF)
    end # printTestStepSummary

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
      print ("Total Tests started at: #{$test_start_time}")
      puts ''
	    print ("Total Tests finished at: #{$test_end_time}")
	    puts ''
	    print ("Total Tests duration: " + TimeDifference.between($test_end_time, $test_start_time).humanize)
	    puts ''
      print ("Total Tests Passed: #{$totalTestPasses}").green
      puts ''
      print ("Total Tests Failed: #{$totalTestFailures}").red
      puts ''
      print ("Total Tests Not Run: #{$totalTestNotrun}").blue
      puts ''
      $totalTests = [$totalTestPasses,$totalTestFailures,$totalTestNotrun].sum
      print ("Total Tests: #{$totalTests}")
      puts ''

      # output to the suite summary file

      # open the suite summary file for writing if not already open
        if (!File.exists?($testSuiteSummaryFileName) || $testSuiteSummaryFileName.closed?)
          $testSuiteSummaryFile = File.open($testSuiteSummaryFileName, 'w')
		      puts ''
		      puts 'Test Suite Summary file located at:'
		      puts "#{$TestSuiteSummaryPDF}"
        elsif
          $log.puts "test suite summary file name: #{$testSuiteSummarylFileName} is already open"
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
		    $testSuiteSummaryFile.write("Total Tests duration: " + TimeDifference.between($test_end_time, $test_start_time).humanize)
		    $testSuiteSummaryFile.puts ''
        $testSuiteSummaryFile.write("Total Tests Passed: #{$totalTestPasses}")
        $testSuiteSummaryFile.puts ''
        $testSuiteSummaryFile.write("Total Tests Failed: #{$totalTestFailures}")
        $testSuiteSummaryFile.puts ''
        $testSuiteSummaryFile.write("Total Tests Not Run: #{$totalTestNotrun}")
        $testSuiteSummaryFile.puts ''
        $testSuiteSummaryFile.write("Total Tests: #{$totalTests}")
        $testSuiteSummaryFile.puts ''

        # if the file is open then close it
        if (!$testSuiteSummaryFile.closed?) then
          $testSuiteSummaryFile.close
        end

	# output to PDF suite summary report
  Prawn::Document.generate($TestSuiteSummaryPDF) do
    text "Finished processing all test files - executed via test suite: #{$testSuiteFile} by tester: #{$tester}"
    text ' '
    text 'Overall Test Summary: '
    $testStepReportSummary.each do |testStepReportSummary|
      text testStepReportSummary
    end
  text ' '
  text("Total Tests started at: #{$test_start_time}")
  text("Total Tests finished at: #{$test_end_time}")
  text("Total Tests duration: " + TimeDifference.between($test_end_time, $test_start_time).humanize)
  text "Total Tests Passed: #{$totalTestPasses}", :color => "00ff00" # green
  text "Total Tests Failed: #{$totalTestFailures}", :color => "ff0000" # red
  text "Total Tests Not Run: #{$totalTestNotrun}", :color => "0000ff" # blue
  text "Total Tests: #{$totalTests}"
  end
end # printOverallTestSummary
end # Report module
