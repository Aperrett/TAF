require_relative 'base_handler'

module TestSteps
  module Handlers
    class Ipause < Base
      register :ipause

      def perform(step_attributes)
        wait_time = step_attributes[:testvalue]

        sleep(wait_time.to_i)
        MyLog.log.info('Wait completed for seconds: ' + wait_time.to_s)
        true
      rescue StandardError
        MyLog.log.warn('Wait failed for seconds: ' + wait_time.to_s)
        false
      end
    end
  end
end