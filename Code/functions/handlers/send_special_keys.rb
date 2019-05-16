# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class SendSpecialKeys < Base
      register :send_special_keys

      def perform(step_attributes)
        special_key = step_attributes[:testvalue]

        Browser.b.send_keys :"#{special_key}"
        sleep 1
        MyLog.log.info("Browser Sent key: :#{special_key} successfully")
        true
      rescue StandardError
        MyLog.log.warn("Browser Failed to Send key: :#{special_key}")
        false
      end
    end
  end
end
