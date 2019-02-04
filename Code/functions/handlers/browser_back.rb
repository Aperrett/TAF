require_relative 'base_handler'

module TestSteps
  module Handlers
    class BrowserBack < Base
      register :browser_back

      def perform(step_attributes)
        Browser.b.back
        MyLog.log.info('Browser navigated back')
        true
      rescue StandardError
        MyLog.log.warn('Browser failed to navigate back')
        false
      end
    end
  end
end