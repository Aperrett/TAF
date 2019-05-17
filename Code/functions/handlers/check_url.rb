# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check URL function.
    class CheckUrl < Base
      register :check_url

      def perform
        if Browser.b.url == @value
          MyLog.log.info("URL: #{@value} is correct")
          true
        else
          MyLog.log.warn("URL: #{@value} is incorrect")
          false
        end
      end
    end
  end
end
