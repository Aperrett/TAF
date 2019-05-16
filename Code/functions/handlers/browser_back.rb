# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Browser Back function.
    class BrowserBack < Base
      register :browser_back

      def perform(_step_attributes)
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
