require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckTitle < Base
      register :check_browser_title

      def perform(step_attributes)
        text_check = step_attributes[:testvalue]

        sleep 2
        if Browser.b.title.eql?(text_check)
          Report.results.puts("Browser title: #{text_check}")
          return true
        else
          Report.results.puts("Title not found: #{text_check}")
          return false
        end
      end
    end
  end
end