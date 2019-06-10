# frozen_string_literal: true

# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # parser.rb - basic parser functions
  module Parser
    def self.test_files
      @test_files ||= Dir.glob("#{Taf::CMDLine.tests_folder}/*.json")
                         .reject do |file|
        File.basename(file).start_with?('~$')
      end.sort
    end

    # readTestData
    def self.read_test_data(test_file_name)
      # get the file type
      file_type = File.extname(test_file_name)
      file_type.casecmp('.json').zero?
      Taf::MyLog.log.info "Processing test file: #{test_file_name}"
      json = File.read(test_file_name)
      parse_json = JSON.parse(json)

      Taf::JSONParser.parse_test_header_data(parse_json)
      parse_json
    end

    # parseTestStepData
    def self.parse_test_step_data(parse_json)
      Taf::JSONParser.parse_test_step_data(parse_json)
    end
  end
end
