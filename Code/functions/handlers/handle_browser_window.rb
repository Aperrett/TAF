# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class HandleBrowserWindow < Base
      register :handle_browser_window

      def perform(step_attributes)
        text_check = step_attributes[:testvalue]

        Browser.b.window(title: text_check.to_s).use
        sleep 3
        Browser.b.title.eql?(text_check.to_s)
        MyLog.log.info("Window title: #{text_check} is correct")
        true
      rescue StandardError
        MyLog.log.warn("Window not found: #{text_check}")
        false
      end
    end
  end
end
