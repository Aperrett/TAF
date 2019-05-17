# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Browser Forward function.
    class BrowserForward < Base
      register :browser_forward

      def perform
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
