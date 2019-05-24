# frozen_string_literal: true

# Created on 13 May 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# cmd_line.rb - command line script Script
module CMDLine
  require_relative '../taf_config.rb'

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
      parser.on(
        '-h',
        '--help',
        "2 arguments are required: {Browser} {Testcase folder}'"
      ) do
        puts parser
        Process.exit
      end

      parser.on(
        '-b',
        '--browser browser',
        'Supported Browsers: chrome,' \
        ' chrome-headless, firefox, firefox-headless'
      ) do |b|
        options[:browser] = b
        @browser_type = options[:browser]
        unless ['chrome', 'chrome-headless', 'firefox', 'firefox-headless']
               .include?(@browser_type)
          MyLog.log.warn 'A valid Browser has not been supplied as a' \
            ' command-line parameter as expected'
          Process.exit
        end
      end

      parser.on('-t', '--tests testfolder', 'i.e. tests/') do |t|
        options[:testfolder] = t
        @tests_folder = options[:testfolder]
        if Parser.test_files.size.positive?
          MyLog.log.info "There are: #{Parser.test_files.size}" \
            ' test files to process'
          MyLog.log.info "List of Tests files: #{Parser.test_files} \n"
        else
          MyLog.log.warn 'A valid Test case location has not been supplied' \
            ' as a command-line parameter as expected'
          Process.exit
        end
      end
    end.parse!
  end

  def self.browser_type
    @browser_type
  end

  def self.tests_folder
    @tests_folder
  end
end
