# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check Screendata text function.
      class CheckScreendata < Base
        register :check_screen_data

        def perform
          Taf::Browser.b.page_source.include? @value
          Taf::MyLog.log.info("Text found: #{@value}")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Text not found: #{@value}")
          false
        end
      end
    end
  end
end
