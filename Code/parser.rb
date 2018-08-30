# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# parser.rb - basic parser functions
module Parser
  require './taf_config.rb'
 # read in the data from the test suite file
  def self.read_test_suite_data
    # check if the file list exists and is readable
    if (File.file?($testSuiteFile) & File.readable?($testSuiteFile))
      puts "\nProcessing test suite file: #{$testSuiteFile}"
      # get the file type
      fileType = File.extname($testSuiteFile)
      # extract the test data from the test suite
      if (fileType.casecmp($XlsxFileNameType) == 0)
        # process as xlsx...
        $XlsxSuiteDoc = RubyXL::Parser.parse($testSuiteFile)
        # ...and parse...
        XlsxParser.parse_xlxs_test_suite_header_data
      else
        # the file type is not that expected so create
        # a error message and raise an exception
        error_to_display = "Test Suite file: '#{$testSuiteFile}' "\
                           "type not recognised (must be .xlsx)"
        raise IOError, error_to_display
      end
        # if unable to read the test file list then construct
        # a custom error message and raise an exception
    elsif error_to_display = "Test Suite file: '#{$testSuiteFile}' "\
                             "does not exist or is unreadable"
        raise IOError, error_to_display
    end
  end

  def self.parse_test_suite_data(testSpecIndex)
    begin
      # get the file type
      fileType = File.extname($testSuiteFile)

      if (fileType.casecmp($XlsxFileNameType) == 0)
        XlsxParser.parse_xlxs_test_suite_data(testSpecIndex)
      else
        # the file type is not that expected so create a
        # error message and raise an exception
        error_to_display = "Test Suite file: '#{$testSuiteFile}' "\
                           "type not recognised (must be .xlsx)"
        raise IOError, error_to_display
      end
    end
  end

  # readTestData
  def self.read_test_data(testFileName)
    # get the file type
    fileType = File.extname(testFileName)
    if (fileType.casecmp($XlsxFileNameType) == 0)
      puts "Processing test file: #{testFileName}"
      puts "Browser Type: #{$browserType}"
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
    # clear the global test step data
    Parser.clear_test_step_data
    XlsxParser.parse_test_step_data(testFileType)
  end

  # clear_test_step_data
  def self.clear_test_step_data
    # clear the global test step data so the value from the previous test,
    # doesn't persist if the read data fails for the current test step
    $testStep         = 0
    $testStepDes      = ''
    $testStepFunction = ''
    $test_value       = ''
    $locate           = ''
    $test_value2      = ''
    $locate2          = ''
    $screenShot       = ''
    $skipTestCase     = ''
  end
end
