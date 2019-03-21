require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckTitle < Base
      register :check_browser_title

      def perform(step_attributes)
        b_title = step_attributes[:testvalue]

        Browser.b.wait_until { Browser.b.title.eql? b_title }
        MyLog.log.info("Browser title: #{b_title}")
        true
      rescue StandardError
        MyLog.log.warn("Title not found: #{b_title}")
        false
      end
    end
  end
end
