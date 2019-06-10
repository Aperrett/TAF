# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Pause the test function.
      class Ipause < Base
        register :ipause

        def perform
          sleep(@value.to_i)
          Taf::MyLog.log.info('Wait completed for seconds: ' + @value.to_s)
          true
        rescue StandardError
          Taf::MyLog.log.warn('Wait failed for seconds: ' + @value.to_s)
          false
        end
      end
    end
  end
end
