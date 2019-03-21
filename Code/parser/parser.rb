# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# parser.rb - basic parser functions
module Parser
  require_relative '../taf_config.rb'
  # variables:
  @xlsx_file_name_type = '.xlsx'

  def self.test_files
    @test_files ||= Dir.glob("#{$testcasesFolder}/*.xlsx").reject do |file|
      File.basename(file).start_with?('~$')
    end.sort
  end

  # readTestData
  def self.read_test_data(test_file_name)
    # get the file type
    file_type = File.extname(test_file_name)
    if file_type.casecmp(@xlsx_file_name_type).zero?
      MyLog.log.info "Processing test file: #{test_file_name}"
      MyLog.log.info "Browser Type: #{$browserType}"
      $xlsxDoc = RubyXL::Parser.parse(test_file_name)
      XlsxParser.parse_xlxs_test_header_data
      return 'XLSX'
    else
      # if unable to read the test file list then construct a custom error
      # message and raise an exception.
      error_to_display = "Test File Name: '#{test_file_name}' " \
                         'type not recognised (must be .xslx)'
      raise IOError, error_to_display
    end

    # if an error occurred reading the test file list then
    # re-raise the exception.
  rescue StandardError => error
    raise IOError, error
  end

  # parseTestStepData
  def self.parse_test_step_data(test_file_type)
    XlsxParser.parse_test_step_data(test_file_type)
  end
end
