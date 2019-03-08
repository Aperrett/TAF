require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckScreendata < Base
      register :check_screen_data

      def perform(step_attributes)
        check_text = step_attributes[:testvalue]

        Browser.b.wait_until { Browser.b.element.text.include? (check_text)}
        MyLog.log.info("Text found: #{check_text}")
        true
      rescue StandardError
        MyLog.log.warn("Text not found: #{check_text}")
        false
      end
    end
  end
end
