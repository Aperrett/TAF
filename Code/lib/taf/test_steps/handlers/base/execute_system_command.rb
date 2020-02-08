# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Execute System Command function.
      class ExecuteSystemCommand < Base
        register :execute_system_command

        def perform
          b_result = system @value
          if b_result == true
            Taf::MyLog.log.info("Cmd has been executed sucessfully #{@value}")
            true
          else
            Taf::MyLog.log.warn("Theres a problem executing command #{@value}")
            false
          end
        end
      end
    end
  end
end
