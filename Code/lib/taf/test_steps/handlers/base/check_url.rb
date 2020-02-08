# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check URL function.
      class CheckUrl < Base
        register :check_url

        def perform
          if Taf::Browser.b.current_url == @value
            Taf::MyLog.log.info("URL: #{@value} is correct")
            true
          else
            Taf::MyLog.log.warn("URL: #{@value} is incorrect")
            false
          end
        end
      end
    end
  end
end
