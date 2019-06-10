# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Browser Quit function.
      class BrowserQuit < Base
        register :browser_quit

        def perform
          Taf::Browser.b.quit
          Taf::MyLog.log.info('Browser has closed successfully')
          true
        rescue StandardError
          Taf::MyLog.log.warn('Browser has failed to close')
          false
        end
      end
    end
  end
end
