# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Handle Browser Window function.
    class HandleBrowserWindow < Base
      register :handle_browser_window

      def perform
        Browser.b.window(title: @value.to_s).use
        sleep 3
        Browser.b.title.eql?(@value.to_s)
        MyLog.log.info("Window title: #{@value} is correct")
        true
      rescue StandardError
        MyLog.log.warn("Window not found: #{@value}")
        false
      end
    end
  end
end
