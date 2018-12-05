require_relative 'base_handler'

module TestSteps
  module Handlers
    class SelectDropdown < Base
      register :select_dropdown

      def perform(step_attributes)
        dropdown = step_attributes[:testvalue]
        value2 = step_attributes[:testvalue2]
        locate = step_attributes[:locate]
        locate2 = step_attributes[:locate2]

        Browser.b.select_list(:"#{locate}" => dropdown).wait_until
        Browser.b.select_list(:"#{locate}" => dropdown).option(:"#{locate2}" => "#{value2}").select
        Report.results.puts("Dropdown item: #{value2} has been selected")
        true
      rescue StandardError
        Report.results.puts("Dropdown item: #{value2} has NOT been selected")
        false
      rescue StandardError
        Report.results.puts("the dropdown: #{dropdown} does not exist")
        false
      end
    end
  end
end