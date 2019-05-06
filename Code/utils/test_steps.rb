# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# test_steps.rb - process the required test step functions
module TestSteps
  require_relative '../taf_config.rb'

  def self.handlers
    @handlers ||= {}
  end

  # process the test step data by matching the test step functions and
  # processing the associated data accordingly
  def self.process_test_steps(test_file_name, test_step_index, step_attributes)
    # print the test step information
    Report.print_test_step_header(test_file_name, test_step_index,
                                  step_attributes)
    runtest = step_attributes[:skipTestCase]
    step_function = step_attributes[:testFunction]
    handler = handlers[step_function.to_s]

    if handler.respond_to?(:perform)
      func = handler.perform(step_attributes) if runtest == false
      Report.test_pass_fail(func, test_file_name, test_step_index,
                            step_attributes)
      Report.check_failure_threshold(test_file_name, test_step_index)
      return true
    else
      MyLog.log.warn "\nUnable to match function: #{step_function}"
      raise UnknownTestStep, "Unknown test step: #{step_function}"
    end
  end
end
