# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Send a Special Key function.
      class SendSpecialKeys < Base
        register :send_special_keys

        def perform
          Taf::Browser.b.send_keys :"#{@value}"
          sleep 1
          Taf::MyLog.log.info("Browser Sent key: :#{@value} successfully")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Browser Failed to Send key: :#{@value}")
          false
        end
      end
    end
  end
end
