# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check Box function.
    class CheckBox < Base
      register :check_box

      def perform(step_attributes)
        checkbox = step_attributes[:testvalue]
        locate = step_attributes[:locate]

        Browser.b.checkbox("#{locate}": checkbox).wait_until(&:exists?).click
        MyLog.log.info("Check box: #{checkbox} has been selected")
        true
      rescue StandardError
        MyLog.log.warn("Check box: #{checkbox} does not exist")
        false
      end
    end
  end
end
