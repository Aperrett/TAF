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
  def self.readTestSuiteData
    # check if the file list exists and is readable
    if (File.file?($testSuiteFile) & File.readable?($testSuiteFile))
      puts ''
      print 'Processing test suite file: ', $testSuiteFile
      puts ''
      # get the file type
      fileType = File.extname($testSuiteFile)
      # extract the test data from the test suite
      if (fileType.casecmp($XlsxFileNameType) == 0)
        # process as xlsx...
        $XlsxSuiteDoc = RubyXL::Parser.parse($testSuiteFile)
        # ...and parse...
        XlsxParser.parseXlxsTestSuiteHeaderData
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

  def self.parseTestSuiteData(testSpecIndex)
    begin
      # get the file type
      fileType = File.extname($testSuiteFile)

      if (fileType.casecmp($XlsxFileNameType) == 0)
        XlsxParser.parseXlxsTestSuiteData(testSpecIndex)
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
  def self.readTestData(testFileName)
    # get the file type
    fileType = File.extname(testFileName)
    if (fileType.casecmp($XlsxFileNameType) == 0)
      puts ''
      print 'Processing test file: ', testFileName
      puts ''
      puts "Browser Type: #{$browserType}"
      $xlsxDoc = RubyXL::Parser.parse(testFileName)
      XlsxParser.parseXlxsTestHeaderData
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
  def self.parseTestStepData(testFileType)
    # clear the global test step data
    Parser.clearTestStepData
    XlsxParser.parseTestStepData(testFileType)
  end

  # clearTestStepData
  def self.clearTestStepData
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
