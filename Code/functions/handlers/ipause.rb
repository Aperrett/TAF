require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class Ipause < Base
      register :ipause

      def perform(step_attributes)
        wait_time = step_attributes[:testvalue]

        sleep(wait_time.to_i)
        Report.results.puts('Wait completed for seconds: ' + wait_time.to_s)
        true
      rescue StandardError
        Report.results.puts('Wait failed for seconds: ' + wait_time.to_s)
        false
      end
    end
  end
end