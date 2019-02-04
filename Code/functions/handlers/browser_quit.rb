require_relative 'base_handler'

module TestSteps
  module Handlers
    class BrowserQuit < Base
      register :browser_quit

      def perform(step_attributes)
        Browser.b.quit
        MyLog.log.info('Browser has closed successfully')
        true
      rescue StandardError
        MyLog.log.warn('Browser has failed to close')
        false
      end
    end
  end
end