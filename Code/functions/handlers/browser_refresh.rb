require_relative 'base_handler'

module TestSteps
  module Handlers
    class BrowserRefresh < Base
      register :browser_refresh

      def perform(step_attributes)
        Browser.b.refresh
        Report.results.puts('The Browser has been refreshed')
        true
      rescue StandardError
        Report.results.puts('The Browser failed to refresh')
        false
      end
    end
  end
end