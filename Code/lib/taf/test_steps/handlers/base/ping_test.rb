# frozen_string_literal: true

module Taf
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
            Taf::MyLog.log.info("pinged: #{@value}")
            return true
          else
            Taf::MyLog.log.warn("Failed to ping: #{@value}")
            return false
          end
        end
      end
    end
  end
end
