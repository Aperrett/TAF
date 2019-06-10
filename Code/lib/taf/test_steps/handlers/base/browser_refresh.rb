# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Browser Refresh function.
      class BrowserRefresh < Base
        register :browser_refresh

        def perform
          Taf::Browser.b.refresh
          Taf::MyLog.log.info('The Browser has been refreshed')
          true
        rescue StandardError
          Taf::MyLog.log.warn('The Browser failed to refresh')
          false
        end
      end
    end
  end
end
