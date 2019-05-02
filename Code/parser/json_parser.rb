# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# json_parser.rb - json parser functions
module JsonParser
  require_relative '../taf_config.rb'

  def self.parse_test_header_data(parse_json)
    # get the number of test steps in the file
    $numberOfTestSteps = parse_json['steps'].count
    # get the remaining test data
    $testId = parse_json['testId']
    $projectId    = parse_json['projectId']
    $testDes      = parse_json['testDescription']
    MyLog.log.info "Number of test steps: #{$numberOfTestSteps}"
    MyLog.log.info "Test Description: #{$testDes}"
    MyLog.log.info "TestID: #{$testId} \n"
  end

  # parseTestStepData
  def self.parse_test_step_data(parse_json)
    parsed_step = {
      testStep: parse_json['currentStep'],
      testdesc: parse_json['description'],
      testFunction: parse_json['function'].downcase,
      testvalue: parse_json['value0'],
      locate: parse_json['value1'] || 'id',
      testvalue2: parse_json['value2'],
      locate2: parse_json['value3'] || 'id',
      screenShotData: parse_json['screenshot'] == 'yes',
      skipTestCase: parse_json['skipTestCase'] == 'yes'
    }

    parsed_step
    # if an error reading the test step data then re-raise the exception
  rescue StandardError => error
    raise error
  end
end
