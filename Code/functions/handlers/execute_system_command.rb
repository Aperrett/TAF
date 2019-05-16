# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Execute System Command function.
    class ExecuteSystemCommand < Base
      register :execute_system_command

      def perform(step_attributes)
        syst_cmd = step_attributes[:testvalue]

        b_result = system syst_cmd
        if b_result == true
          MyLog.log.info("Cmd has been executed sucessfully #{syst_cmd}")
          return true
        else
          MyLog.log.warn("Theres a problem executing command #{syst_cmd}")
          return false
        end
      end
    end
  end
end
