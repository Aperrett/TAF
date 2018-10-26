require_relative 'base_handler'

module TestSteps
  module Handlers
    class ExecuteSystemCommand < Base
      register :execute_system_command

      def perform(step_attributes)
        syst_cmd = step_attributes[:testvalue]

        b_result = system syst_cmd
        if b_result == true
          Report.results.puts("Cmd has been executed sucessfully #{syst_cmd}")
          return true
        else
          Report.results.puts("Theres a problem executing command #{syst_cmd}")
          return false
        end
      end
    end
  end
end