# frozen_string_literal: true

# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# parser.rb - basic parser functions
module Parser
  require_relative '../taf_config.rb'

  def self.test_files
    @test_files ||= Dir.glob("#{CMDLine.tests_folder}/*.json").reject do |file|
      File.basename(file).start_with?('~$')
    end.sort
  end

  # readTestData
  def self.read_test_data(test_file_name)
    # get the file type
    file_type = File.extname(test_file_name)
    if file_type.casecmp('.json').zero?
      MyLog.log.info "Processing test file: #{test_file_name}"
      json = File.read(test_file_name)
      parse_json = JSON.parse(json)

      JsonParser.parse_test_header_data(parse_json)
      return parse_json
    else
      # if unable to read the test file list then construct a custom error
      # message and raise an exception.
      MyLog.log.info 'Not a valid JSON File Type' if test_file_name != 'JSON'
      error_to_display = "Test File Name: '#{test_file_name}' " \
                         'type not recognised (must be .xslx or .json)'
      raise IOError, error_to_display
    end

    # if an error occurred reading the test file list then
    # re-raise the exception.
  rescue StandardError => e
    raise IOError, e
  end

  # parseTestStepData
  def self.parse_test_step_data(parse_json)
    JsonParser.parse_test_step_data(parse_json)
  end
end
