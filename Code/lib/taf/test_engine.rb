# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # test_engine.rb - controls the iteration through the test suite and specs
  module TestEngine
    def self.get_test_data(test_file_name)
      # read in the test data
      tests = Taf::Parser.read_test_data(test_file_name)
      tests
    # if unable to read the test data, show the error and move onto the
    # next file (if there is one)
    rescue StandardError => e
      Taf::MyLog.log.warn 'Terminating the current test spec: ' \
                   "#{test_file_name} #{e}"
      Taf::MyLog.log.info
      '...continuing with the next test file (if there is one)'
    end

    def self.get_step_data(test_file_name, tests, metrics)
      tests['steps'].each_with_index do |test_step, test_step_idx|
        test_step_idx += 1

        parsed_steps = Taf::Parser.parse_test_step_data(test_step)

        # process the test step data
        Taf::TestSteps.process_test_steps(test_file_name, test_step_idx,
                                          parsed_steps, metrics)
      end
    rescue Taf::TafError => e
      warn e
      Taf::MyLog.log.warn e
    end

    # process the test files to execute the tests
    def self.process_testfiles
      total_passes = 0
      total_failures = 0
      total_skipped = 0

      # loop through all the available test files to execute the tests
      Taf::Parser.test_files.each_with_index do |test_file_name, test_file_idx|
        metrics = Struct.new(:stepPasses, :stepFailures, :stepSkipped)
                        .new(0, 0, 0)

        tests = get_test_data(test_file_name)

        # create project folders - these only need creating once per test suite
        Taf::CreateDirectories.construct_projectdirs

        Taf::Browser.open_browser
        get_step_data(test_file_name, tests, metrics)

        # output the test results summary to console
        Taf::ReportSummary.test_step_summary(test_file_name, test_file_idx,
                                             metrics)

        # close the browser if created
        Taf::Browser.b.quit

        # record total passes and failures and reset the failure counters for
        # the test steps
        total_passes   += metrics.stepPasses
        total_failures += metrics.stepFailures
        total_skipped  += metrics.stepSkipped
      end

      [total_passes, total_failures, total_skipped]
    end
  end
end
