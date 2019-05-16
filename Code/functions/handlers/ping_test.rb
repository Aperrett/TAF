# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Png Test function.
    class PingTest < Base
      register :ping_test

      # TODO: retry every 'x' until timeout reached.
      def perform(step_attributes)
        url = step_attributes[:testvalue]

        check = Net::Ping::HTTP.new(url)

        check.ping?
        sleep 5
        if check.ping?
          MyLog.log.info("pinged: #{url}")
          return true
        else
          MyLog.log.warn("Failed to ping: #{url}")
          return false
        end
      end
    end
  end
end
