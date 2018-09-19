# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# test_steps.rb - process the required test step functions
module TestSteps
  require './taf_config.rb'
  
  def self.handlers
    @handlers ||= {}
  end

  # process the test step data by matching the test step functions and
  # processing the associated data accordingly
  def self.process_test_steps(test_file_name, teststepindex, step_attributes)
    # print the test step information
    Report.print_test_step_header(test_file_name, teststepindex)
 
    runtest = step_attributes[:skipTestCase]
    step_function = step_attributes[:testFunction]
    handler = handlers[step_function.to_s]

    if handler.respond_to?(:perform)
      func = handler.perform(step_attributes) if runtest == false
      Report.test_pass_fail(func, test_file_name, teststepindex)
      Report.check_failure_threshold(test_file_name, teststepindex)
      return true
    else
      Report.results.puts("\nUnable to match function: #{step_function}")
      puts "\nUnable to match function: #{step_function}"
      raise UnknownTestStep, "Unknown test step: #{step_function}"
      return false
    end
  end
end

# Require all test step handlers, which register themselves with
# TestStep.handlers when the files are required.
require_relative 'functions/handlers'
