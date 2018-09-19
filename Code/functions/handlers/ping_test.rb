require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class PingTest < Base
      register :ping_test

      def perform(step_attributes)
        url = step_attributes[:testvalue]

        while pingtest == Net::Ping::HTTP.new(url)
          pingtest.ping?
          sleep 5
          if pingtest.ping? == true
            # website alive
            Report.results.puts("pinged: #{url}")
            return true
          else
            # website not responding
            Report.results.puts("Failed to ping: #{url}")
            return false
          end
        end
      end
    end
  end
end