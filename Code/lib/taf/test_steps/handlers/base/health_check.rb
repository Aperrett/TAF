# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Health Check function to check the status of a web address or ip.
      class HealthCheck < Base
        register :health_check

        def perform
          tries ||= 20
          res = Faraday.get(@value)
          status = res.status
        rescue Faraday::Error
          if (tries -= 1).positive?
            sleep 1
            puts "Failed to ping: #{@value} - Retries left: #{tries}"
            retry
          else
            Taf::MyLog.log.warn("Site Error: #{@value} status code: #{status}")
            false
          end
        else
          Taf::MyLog.log.info("Site: #{@value} status code: #{status}")
          true
        end
      end
    end
  end
end
