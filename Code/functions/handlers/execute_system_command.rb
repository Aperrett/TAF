# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Execute System Command function.
    class ExecuteSystemCommand < Base
      register :execute_system_command

      def perform
        b_result = system @value
        if b_result == true
          MyLog.log.info("Cmd has been executed sucessfully #{@value}")
          return true
        else
          MyLog.log.warn("Theres a problem executing command #{@value}")
          return false
        end
      end
    end
  end
end
