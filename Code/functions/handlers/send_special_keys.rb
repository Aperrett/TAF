# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Send a Special Key function.
    class SendSpecialKeys < Base
      register :send_special_keys

      def perform
        Browser.b.send_keys :"#{@value}"
        sleep 1
        MyLog.log.info("Browser Sent key: :#{@value} successfully")
        true
      rescue StandardError
        MyLog.log.warn("Browser Failed to Send key: :#{@value}")
        false
      end
    end
  end
end
