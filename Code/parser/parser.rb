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
  @XlsxFileNameType = '.xlsx'

  def self.test_files
    @test_files ||= Dir.glob("#{$testcasesFolder}/*.xlsx").reject do |file|
      File.basename(file).start_with?('~$')
    end.sort
  end

  # readTestData
  def self.read_test_data(testFileName)
    # get the file type
    fileType = File.extname(testFileName)
    if (fileType.casecmp(@XlsxFileNameType) == 0)
      MyLog.log.info "Processing test file: #{testFileName}"
      MyLog.log.info "Browser Type: #{$browserType}"
      $xlsxDoc = RubyXL::Parser.parse(testFileName)
      XlsxParser.parse_xlxs_test_header_data
      return 'XLSX'
    else
      # if unable to read the test file list then construct a custom error
      # message and raise an exception.
      error_to_display = "Test File Name: '#{testFileName}' " \
                         "type not recognised (must be .xslx)"
      raise IOError, error_to_display
    end

    # if an error occurred reading the test file list then
    # re-raise the exception.
  rescue StandardError => error
    raise IOError, error
  end

  # parseTestStepData
  def self.parse_test_step_data(testFileType)
    XlsxParser.parse_test_step_data(testFileType)
  end
end
