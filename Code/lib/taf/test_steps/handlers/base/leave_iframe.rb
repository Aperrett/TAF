# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Handle leave iframe function.
      class LeaveIframe < Base
        register :leave_iframe

        def perform
          # Return to the top level
          Taf::Browser.b.switch_to.default_content
          Taf::MyLog.log.info('iframe switched to top level successfully')
          true
        rescue StandardError
          Taf::MyLog.log.warn('iframe failed to switched to top level')
          false
        end
      end
    end
  end
end
