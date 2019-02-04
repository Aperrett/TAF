require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckUrl < Base
      register :check_url

      def perform(step_attributes)
        url = step_attributes[:testvalue]

        if Browser.b.url == url
          MyLog.log.info("URL: #{url} is correct")
          true
        else
          MyLog.log.warn("URL: #{url} is incorrect")
          false
        end
      end
    end
  end
end