# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# xlsx_parser.rb - xlsx parser functions
module XlsxParser
  require_relative '../taf_config.rb'

  def self.parse_xlxs_test_header_data
    # get the number of test steps in the file
    $numberOfTestSteps = ($xlsxDoc[0].sheet_data.size) - 4
    worksheet = $xlsxDoc[0]
    # get the remaining test data
    $testId    = worksheet.sheet_data[1][0].value
    $projectId    = worksheet.sheet_data[1][1].value
    $testDes      = worksheet.sheet_data[1][2].value
    MyLog.log.info "Number of test steps: #{$numberOfTestSteps}"
    MyLog.log.info "Test Description: #{$testDes}"
    MyLog.log.info "TestID: #{$testId} \n"
    
  end

  # parseTestStepData
  def self.parse_test_step_data(testFileType)
    begin
    worksheet = $xlsxDoc[0]
    worksheet[4..$numberOfTestSteps+4].map do |row|
      test = {
        testStep: row[0].value,
        testdesc: row[1].value,
        testFunction: row[2].value,
        testvalue: row[3].value,
        locate: row[4].value,
        testvalue2: row[5].value,
        locate2: row[6].value,
        screenShotData: row[7].value,
        skipTestCase: row[8].value,
      }

      # convert test step, screenshot and skip test case functions to lowercase.
      test[:testFunction].downcase!

      # get screenshot request, check for a null value and default to 'N'

      if (test[:screenShotData] == 'Y')
        test[:screenShotData] = true
      elsif (test[:screenShotData] == 'N')
        test[:screenShotData] = false
      else
        test[:screenShotData] = false
      end

      if (test[:skipTestCase] == 'Y')
        test[:skipTestCase] = true
      elsif(test[:skipTestCase] == 'N')
        test[:skipTestCase] = false
      else
        test[:skipTestCase] = false
      end

      # if there is an element locator then use it, otherwise use an ID
      if (test[:locate].to_s == '')
        test[:locate] = 'id'
      end

      if (test[:locate2].to_s == '')
        test[:locate2] = 'id'
      end

      test
     # if an error reading the test step data then re-raise the exception
    rescue StandardError => error
      raise
    end
  end
end
end
