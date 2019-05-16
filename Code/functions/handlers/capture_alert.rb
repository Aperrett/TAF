# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class CaptureAlert < Base
      register :capture_alert

      def perform(_step_attributes)
        Browser.b.div(class: 'alert').exist?
        alertmsg = Browser.b.div(class: 'alert').text
        MyLog.log.info("Alert shown: #{alertmsg}")
        true
      rescue StandardError
        MyLog.log.warn('No Alert Found')
        false
      end
    end
  end
end
