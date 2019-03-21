# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# main.rb - Framework Driver Script
module Main
  require_relative './taf_config.rb'

  def self.cmdline_input
    # check if the test suite file name exists on the command line
    # allow a user to input 2 arguments in to CMD line the 2 values are:
    # Testcase Folder and Browser.
    options = {}
    ARGV.push('-h') if ARGV.empty?
    OptionParser.new do |parser|
      # Whenever we see -b, -t or --browser, or --tests with an
      # argument, save the argument.
      parser.banner = 'Usage: taf [options]'
      parser.on('-h', '--help', "2 arguments are required: {Browser} {Testcase folder}'") do
        puts parser
        Process.exit
      end

      parser.on('-b', '--browser browser', 'Supported Browsers: chrome, chrome-headless, firefox, firefox-headless.') do |b|
        options[:browser] = b
        $browserType = options[:browser]
        unless ['chrome', 'chrome-headless', 'firefox', 'firefox-headless'].include?($browserType)
          MyLog.log.warn 'A valid Browser has not been supplied as a command-line parameter as expected'
          Process.exit
        end
      end

      parser.on('-t', '--tests testfolder', 'i.e. tests/') do |t|
        options[:testfolder] = t
        $testcasesFolder = options[:testfolder]
        if Parser.test_files.size.positive?
          MyLog.log.info "There are: #{Parser.test_files.size} test files to process"
          MyLog.log.info "List of Tests files: #{Parser.test_files} \n"
        else
          MyLog.log.warn 'A valid Test case location has not been supplied as a command-line parameter as expected'
          Process.exit
        end
      end
    end.parse!
  end

  begin
     # variables to manage the failure reporting
     $testStepPasses     = 0
     $testStepFailures   = 0
     $testStepNotrun     = 0
     $totalTestPasses    = 0
     $totalTestFailures  = 0
     $totalTestNotrun = 0
     $previousTestFail = false
     $currentTestFail = false
     # initialised stores for the input xlsx test data
     $XlsxDoc = ''
     # parses the cmd line imput into the taf
     Main.cmdline_input
   end

  # process the test files to execute the tests
  TestEngine.process_testfiles

  # get the overall test end time
  $test_end_time = Report.current_time

  # output the overall test summary
  ReportSummary.print_overall_test_summary
  JunitReport.test_summary_junit

  # Exit status code.
  Process.exit($totalTestFailures.zero? ? 0 : 1)
end
