# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # test_steps.rb - process the required test step functions
  module TestSteps
    def self.handlers
      @handlers ||= {}
    end

    # process the test step data by matching the test step functions and
    # processing the associated data accordingly
    def self.process_test_steps(test_file_name, test_step_idx, step_attributes,
                                metrics)
      # print the test step information
      Taf::Report.print_test_step_header(test_step_idx,
                                         step_attributes[:testdesc])
      runtest = step_attributes[:skipTestCase]
      step_function = step_attributes[:testFunction]
      handler = handlers[step_function.to_s]

      if handler.respond_to?(:perform)
        func = handler.perform(step_attributes) if runtest == false
        Taf::Report.test_pass_fail(
          func,
          test_file_name,
          test_step_idx,
          step_attributes[:testdesc],
          metrics
        )
        Taf::Report.check_failure_threshold(test_file_name)
        true
      else
        Taf::MyLog.log.warn "\nUnable to match function: #{step_function}"
        raise Taf::UnknownTestStep, "Unknown test step: #{step_function}"
      end
    end
  end
end
