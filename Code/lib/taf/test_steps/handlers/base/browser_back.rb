# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Browser Back function.
      class BrowserBack < Base
        register :browser_back

        def perform
          Taf::Browser.b.navigate.back
          Taf::MyLog.log.info('Browser navigated back')
          true
        rescue StandardError
          Taf::MyLog.log.warn('Browser failed to navigate back')
          false
        end
      end
    end
  end
end
