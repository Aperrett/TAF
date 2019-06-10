# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Browser Forward function.
      class BrowserForward < Base
        register :browser_forward

        def perform
          Taf::Browser.b.forward
          Taf::MyLog.log.info('Browser navigated forward')
          true
        rescue StandardError
          Taf::MyLog.log.warn('Browser failed to navigate forward')
          false
        end
      end
    end
  end
end
