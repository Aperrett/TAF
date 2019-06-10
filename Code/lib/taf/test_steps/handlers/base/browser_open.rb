# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Browser Open function.
      class BrowserOpen < Base
        register :browser_open

        def perform
          Taf::Browser.open_browser
          Taf::MyLog.log.info('Browser has opened successfully')
          true
        rescue StandardError
          Taf::MyLog.log.warn('Browser has failed to open')
          false
        end
      end
    end
  end
end
