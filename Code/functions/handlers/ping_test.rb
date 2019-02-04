require_relative 'base_handler'

module TestSteps
  module Handlers
    class PingTest < Base
      register :ping_test

      def perform(step_attributes)
        url = step_attributes[:testvalue]

        while check = Net::Ping::HTTP.new(url)
          check.ping?
          sleep 5
          if check.ping? == true
            # website alive
            MyLog.log.info("pinged: #{url}")
            return true
          else
            # website not responding
            MyLog.log.warn("Failed to ping: #{url}")
            return false
          end
        end
      end
    end
  end
end