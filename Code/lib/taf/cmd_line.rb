# frozen_string_literal: true

# Created on 13 May 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # cmd_line.rb - command line script Script
  module CMDLine
    def self.help
      puts '  Usage: taf [options]'
      puts '-h --help 2 arguments are required: -b {Browser}'\
              '-t {Testcase folder}'
      puts '-v --verision Shows current version'
      puts '-b --browser browser Supported Browsers: chrome, chrome-headless,'\
              ' firefox, firefox-headless'
      puts '-t --tests testfolder i.e. tests/*.json'
      Process.exit
    end

    def self.browser(browser)
      @browser_type = browser
      unless ['chrome', 'chrome-headless', 'firefox', 'firefox-headless']
             .include?(@browser_type)
        Taf::MyLog.log.warn 'A valid Browser has not been supplied as a' \
                  ' command-line parameter as expected'
        Process.exit
      end
    end

    def self.tests(testfolder)
      @tests_folder = testfolder
      if Taf::Parser.test_files.size.positive?
        Taf::MyLog.log.info "There are: #{Taf::Parser.test_files.size}" \
          " test files to process: #{Taf::Parser.test_files}\n"
      else
        Taf::MyLog.log.warn \
          'A valid Test case location has not been supplied' \
          ' as a command-line parameter as expected, Files should be .JSON'
        Process.exit
      end
    end

    def self.taf_version
      puts "TAF Version: #{Taf::VERSION}"
      Process.exit
    end

    def self.browser_type
      @browser_type
    end

    def self.tests_folder
      @tests_folder
    end

    def self.cmdline_input
      # check if the test suite file name exists on the command line
      # allow a user to input 2 arguments in to CMD line the 2 values are:
      # Testcase Folder and Browser.
      options = {}
      ARGV.push('-h') if ARGV.empty?
      OptionParser.new do |opt|
        opt.banner = 'Usage: taf [options]'
        opt.on('-h', '--help') { help }
        opt.on('-v', '--version') { taf_version }
        opt.on('-b', '--browser b') { |b| options[:browser] = b, browser(b) }
        opt.on('-t', '--tests t') { |t| options[:testfolder] = t, tests(t) }
      end.parse!
    end
  end
end
