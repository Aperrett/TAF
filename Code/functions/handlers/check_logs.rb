# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class CheckLogs < Base
      register :check_log_file

      def perform(step_attributes)
        text = step_attributes[:testvalue]
        file = step_attributes[:testvalue2]

        blog_result = system 'egrep -i ' + text + ' ' + file + ' > ' + output
        if blog_result == true
          MyLog.log.info("Data has matched: #{text} in LogFile: #{file}")
          return true
        else
          MyLog.log.warn("Problem finding: #{text} in LogFile: #{file}")
          return false
        end
      end
    end
  end
end
