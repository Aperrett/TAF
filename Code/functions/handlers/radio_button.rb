require_relative 'base_handler'

module TestSteps
  module Handlers
    class RadioButton < Base
      register :radio_button

      def perform(step_attributes)
        radio = step_attributes[:testvalue]
        value2 = step_attributes[:testvalue2]
        locate = step_attributes[:locate]
        locate2 = step_attributes[:locate2]

        Browser.b.radio(:"#{locate}" => radio).wait_until_present
        Browser.b.radio(:"#{locate}" => radio, :"#{locate2}" => "#{value2}").set
        Report.results.puts("Radio button: #{radio} has been selected")
        true
      rescue StandardError
        Report.results.puts("Radio button: #{radio} does not exist")
        false
      end
    end
  end
end