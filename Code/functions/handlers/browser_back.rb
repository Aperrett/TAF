require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class BrowserBack < Base
      register :browser_back

      def perform(step_attributes)
        Browser.b.back
        Report.results.puts('Browser navigated back')
        true
      rescue StandardError
        Report.results.puts('Browser failed to navigate back')
        false
      end
    end
  end
end