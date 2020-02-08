# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Handle Browser Window function.
      class HandleBrowserWindow < Base
        register :handle_browser_window

        def perform
          Taf::Browser.b.window_handles.each do |handle|
            Taf::Browser.b.switch_to.window handle
            sleep 3
            Taf::Browser.b.title.eql?(@value.to_s)
            Taf::MyLog.log.info("Window title: #{@value} is correct")
            true
          rescue StandardError
            Taf::MyLog.log.warn("Window not found: #{@value}")
            false
          end
        end
      end
    end
  end
end
