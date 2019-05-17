# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Png Test function.
    class PingTest < Base
      register :ping_test

      # TODO: retry every 'x' until timeout reached.
      def perform
        check = Net::Ping::HTTP.new(@value)

        check.ping?
        sleep 5
        if check.ping?
          MyLog.log.info("pinged: #{@value}")
          return true
        else
          MyLog.log.warn("Failed to ping: #{@value}")
          return false
        end
      end
    end
  end
end
