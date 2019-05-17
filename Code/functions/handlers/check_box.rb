# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check Box function.
    class CheckBox < Base
      register :check_box

      def perform
        Browser.b.checkbox("#{@locate}": @value).wait_until(&:exists?).click
        MyLog.log.info("Check box: #{@value} has been selected")
        true
      rescue StandardError
        MyLog.log.warn("Check box: #{@value} does not exist")
        false
      end
    end
  end
end
