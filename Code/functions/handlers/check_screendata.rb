# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check Screendata text function.
    class CheckScreendata < Base
      register :check_screen_data

      def perform
        Browser.b.wait_until { Browser.b.element.text.include? @value }
        MyLog.log.info("Text found: #{@value}")
        true
      rescue StandardError
        MyLog.log.warn("Text not found: #{@value}")
        false
      end
    end
  end
end
