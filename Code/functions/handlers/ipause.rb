# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Pause the test function.
    class Ipause < Base
      register :ipause

      def perform
        sleep(@value.to_i)
        MyLog.log.info('Wait completed for seconds: ' + @value.to_s)
        true
      rescue StandardError
        MyLog.log.warn('Wait failed for seconds: ' + @value.to_s)
        false
      end
    end
  end
end
