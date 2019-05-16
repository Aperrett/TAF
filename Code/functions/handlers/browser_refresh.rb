# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class BrowserRefresh < Base
      register :browser_refresh

      def perform(_step_attributes)
        Browser.b.refresh
        MyLog.log.info('The Browser has been refreshed')
        true
      rescue StandardError
        MyLog.log.warn('The Browser failed to refresh')
        false
      end
    end
  end
end
