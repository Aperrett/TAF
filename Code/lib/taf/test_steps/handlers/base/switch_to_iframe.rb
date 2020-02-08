# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Handle switch to iframe function.
      class SwitchToIframe < Base
        register :switch_to_iframe

        def perform
          Taf::Browser.b.switch_to.frame @value.to_s
          Taf::MyLog.log.info("Switched to iframe: #{@value} successfully")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Failed to switch to iframe: #{@value}")
          false
        end
      end
    end
  end
end
