require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckScreendata < Base
      register :check_screen_data

      def perform(step_attributes)
        text_check = step_attributes[:testvalue]

        sleep 5
        if Browser.b.text.include?(text_check)
          Report.results.puts("Found text: #{text_check}")
          return true
        else
          Report.results.puts("NOT found text: #{text_check}")
          return false
        end
      end
    end
  end
end