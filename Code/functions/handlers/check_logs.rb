# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Check a log file function.
    class CheckLogs < Base
      register :check_log_file

      def perform
        result = system 'egrep -i ' + @value + ' ' + @value2 + ' > ' + output
        if result == true
          MyLog.log.info("Data has matched: #{@value} in LogFile: #{@value2}")
          return true
        else
          MyLog.log.warn("Problem finding: #{@value} in LogFile: #{@value2}")
          return false
        end
      end
    end
  end
end
