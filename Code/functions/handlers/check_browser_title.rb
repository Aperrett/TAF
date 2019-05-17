# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check Browser Title function.
    class CheckTitle < Base
      register :check_browser_title

      def perform
        Browser.b.wait_until { Browser.b.title.eql? @value }
        MyLog.log.info("Browser title: #{@value}")
        true
      rescue StandardError
        MyLog.log.warn("Title not found: #{@value}")
        false
      end
    end
  end
end
