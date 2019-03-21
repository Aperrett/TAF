require_relative 'base_handler'

module TestSteps
  module Handlers
    class BrowserForward < Base
      register :browser_forward

      def perform(_step_attributes)
        Browser.b.forward
        MyLog.log.info('Browser navigated forward')
        true
      rescue StandardError
        MyLog.log.warn('Browser failed to navigate forward')
        false
      end
    end
  end
end
