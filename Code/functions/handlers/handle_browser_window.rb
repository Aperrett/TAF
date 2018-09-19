require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class HandleBrowserWindow < Base
      register :handle_browser_window

      def perform(step_attributes)
        text_check = step_attributes[:testvalue]

        Browser.b.window(title: text_check.to_s).use
        sleep 3
        Browser.b.title.eql?(text_check.to_s)
        Report.results.puts("Window title: #{text_check} is correct")
        true
      rescue StandardError
        Report.results.puts("Window not found: #{text_check}")
        false
      end
    end
  end
end