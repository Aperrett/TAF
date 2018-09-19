require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class BrowserForward < Base
      register :browser_forward

      def perform(step_attributes)
        Browser.b.forward
        Report.results.puts('Browser navigated forward')
        true
      rescue StandardError
        Report.results.puts('Browser failed to navigate forward')
        false
      end
    end
  end
end