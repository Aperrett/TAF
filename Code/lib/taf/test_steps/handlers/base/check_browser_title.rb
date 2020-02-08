# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check Browser Title function.
      class CheckTitle < Base
        register :check_browser_title

        def perform
          Taf::Browser.b.title.eql? @value
          Taf::MyLog.log.info("Browser title: #{@value}")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Title not found: #{@value}")
          false
        end
      end
    end
  end
end
