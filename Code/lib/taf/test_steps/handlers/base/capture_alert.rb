# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Capture Alert function.
      class CaptureAlert < Base
        register :capture_alert

        def perform
          Taf::Browser.b.find_element(class: 'alert').displayed?
          alertmsg = Taf::Browser.b.find_element(class: 'alert').text
          Taf::MyLog.log.info("Alert shown: #{alertmsg}")
          true
        rescue StandardError
          Taf::MyLog.log.warn('No Alert Found')
          false
        end
      end
    end
  end
end
