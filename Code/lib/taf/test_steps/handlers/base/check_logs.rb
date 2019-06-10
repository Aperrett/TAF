# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check a log file function.
      class CheckLogs < Base
        register :check_log_file

        def perform
          result = system 'egrep -i ' + @value + ' ' + @value2 + ' > ' + output
          if result == true
            Taf::MyLog.log.info \
              "Data has matched: #{@value} in LogFile: #{@value2}"
            return true
          else
            Taf::MyLog.log.warn \
              "Problem finding: #{@value} in LogFile: #{@value2}"
            return false
          end
        end
      end
    end
  end
end
