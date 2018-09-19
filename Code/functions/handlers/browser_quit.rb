require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class BrowserQuit < Base
      register :browser_quit

      def perform(step_attributes)
        Browser.b.quit
        Report.results.puts('Browser has closed successfully')
        true
      rescue StandardError
        Report.results.puts('Browser has failed to close')
        false
      end
    end
  end
end