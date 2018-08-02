# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# csv_parser.rb - CSV parser functions
module CsvParser
  require './taf_config.rb'
  def self.parseCsvTestSuiteHeaderData
    begin
      # each row in the input file is stored as an array of elements:
      # row0: header row containing test suite title fields
      # row1: Project_Name, Project_ID, Sprint
      # row2: nil
      # row3: header row containing test suite title fields
      # row4: Test_Suite, Suite_Description, Tester
      # row5: nil
      # row6: header row containing test suite title fields
      # row7: Test_ID, Test_Specification, Browser_Type
      # row8: repeat of previous row with each test spec file until <endOfFile>

      # get the number of test specifications in the file:
      # (number or rows - number of non test spec rows)
      $numberOfTestSpecs = ($CsvSuiteDoc.length) - 7

      # get the CSV file row containing the header data
      headerRow     = $CsvSuiteDoc[1]
      $projectName  = headerRow[0, 1][0]
      $projectId    = headerRow[1, 1][0]
      $sprint       = headerRow[2, 1][0]

      # get the CSV file row containing more header data
      headerRow = $CsvSuiteDoc[4]
      $testSuiteId  = headerRow[0, 1][0]
      $testSuiteDes = headerRow[1, 1][0]
      $tester       = headerRow[2, 1][0]
    end
  end

  # parseCsvTestSuiteData
  def self.parseCsvTestSuiteData(testSpecIndex)
    begin
      # each row in the input file is stored as an array of elements:
      # row0: header row containing test suite title fields
      # row1: Project_Name, Project_ID, Sprint
      # row2: nil
      # row3: header row containing test suite title fields
      # row4: Test_Suite, Suite_Description, Tester
      # row5: nil
      # row6: header row containing test suite title fields
      # row7: Test_ID, Test_Specification, Browser_Type, Environment type
      # row8: repeat of previous row with each test spec file until <endOfFile>

      # get the CSV file row containing the desired test spec data
      headerRow = $CsvSuiteDoc[testSpecIndex + 7]
      $testId        = headerRow[0, 1][0]
      $testSpecDesc  = headerRow[1, 1][0]
      $env_type      = headerRow[3, 1][0]
      
      if ARGV.length < 2
        $browserType = headerRow[2, 1][0]
        puts "Will use the following browser from Test Suite: " + $browserType
        puts ''
      elsif ARGV.length < 3
        $browserType = ARGV[1]
        puts "Will use the following browser from CMD line: " + ARGV[1]
        puts ''
      else
        $browserType = 'unknown'
        error_to_display = 'Unable to open browser'
        raise IOError, error_to_display  
      end  
    end
  end

  # parseCsvTestHeaderData
  def self.parseCsvTestHeaderData
    # each row in the input file is stored as an array of elements:
    # row0: header row containing the header title fields
    # row1: Project_Name, Project_ID, Sprint
    # row2: nil
    # row3: header row containing the test header title fields
    # row4: Test_ID, Test_Description, Browser_Type
    # row5: nil
    # row6: header row containing the test step header title fields
    # row7: Test_Step, Test_Step_Description, Test_Step_Function,
    # Test_Step_Value, S, Test_Step_Value2, Screenshot, nil
    # repeat of previous row with each test step data until <endOfFile>

    # get the number of test steps in the file:
    # (number or rows - number of non-test step rows)
    $numberOfTestSteps = ($CsvDoc.length) - 7

    # NB: the projectName, projectId and sprint data
    # is now sourced from the test suite file

    # get the CSV file row containing the header data
    # NB: the testId and browserType data is now sourced from the testsuite file
    headerRow = $CsvDoc[4]
    $testDes = headerRow[1, 1][0]
    puts "Number of test steps: #{$numberOfTestSteps}"
    puts "Test Description: #{$testDes}"
  end

  # parseTestStepData
  def self.parseTestStepData(testFileType, testStepIndex)
    begin
      # each row in the input file is stored as an array of elements:
      # row0: header row containing the header title fields
      # row1: Project_Name, Project_ID, Sprint
      # row2: nil
      # row3: header row containing the test header title fields
      # row4: Test_ID, Test_Description, Browser_Type
      # row5: nil
      # row6: header row containing the test step header title fields
      # row7: Test_Step, Test_Step_Description, Test_Step_Function,
      # Test_Step_Value, Test_Step_Value2, Screenshot, Skip_Test_Case, nil
      # repeat of previous row with each test step data until...
      # nil, <endOfFile>

      row = $CsvDoc[testStepIndex]

      # read data
      $testStep         = row[0, 1][0]
      $testStepDes      = row[1, 1][0]
      $testStepFunction = row[2, 1][0]
      $test_value       = row[3, 1][0]
      $locate           = row[4, 1][0]
      $test_value2      = row[5, 1][0]
      $locate2          = row[6, 1][0]

      # get screenshot request, check for a null value and default to 'N'
      screenShotData    = row[7, 1][0]

      if (screenShotData.to_s.empty?)
        $screenShot = 'N'
      else
        $screenShot = screenShotData
      end

      # get skipped test request, check for a null value and default to 'N'
      skipTestData      = row[8, 1][0]

      if (skipTestData.to_s.empty?)
        $skipTestCase = 'N'
      else
        $skipTestCase = skipTestData
      end

      # convert test step function to lower case to remove any case-variation
      $testStepFunction.downcase!

      # convert to lower case and then to a boolean value
      $screenShot.downcase!
      if ($screenShot == 'y')
        $screenShot = true
      else
        $screenShot = false
      end

      # convert skip test case to lower case and then to a boolean value
      $skipTestCase.downcase!
      if ($skipTestCase == 'y')
        $skipTestCase = true
      else
        $skipTestCase = false
      end

      # if there is an element locator then use it, otherwise use an ID
      if ($locate.to_s == '')
        $locate = 'id'
      end

      if ($locate2.to_s == '')
        $locate2 = 'id'
      end

      # if an error reading the test step data then re-raise the exception
      rescue StandardError => error
        raise
      end
    end
end
