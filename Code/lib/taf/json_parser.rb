# frozen_string_literal: true

# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # json_parser.rb - json parser functions
  module JSONParser
    def self.parse_test_header_data(parse_json)
      # get the number of test steps in the file
      number_test_steps = parse_json['steps'].count
      # get the remaining test data
      @test_id = parse_json['testId']
      @project_id = parse_json['projectId']
      test_des = parse_json['testDescription']
      Taf::MyLog.log.info "Number of test steps: #{number_test_steps}"
      Taf::MyLog.log.info "Test Description: #{test_des}"
      Taf::MyLog.log.info "TestID: #{@test_id} \n"
    end

    def self.test_id
      @test_id
    end

    def self.project_id
      @project_id
    end

    # parseTestStepData
    def self.parse_test_step_data(parse_json)
      parsed_step = { testdesc: parse_json['description'],
                      testFunction: parse_json['function'].downcase,
                      testvalue: parse_json['value0'],
                      locate: parse_json['value1'] || 'id',
                      testvalue2: parse_json['value2'],
                      skipTestCase: parse_json['skipTestCase'] == 'yes' }

      parsed_step
      # if an error reading the test step data then re-raise the exception
    rescue StandardError => e
      raise e
    end
  end
end
