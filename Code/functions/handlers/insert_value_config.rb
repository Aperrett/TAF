require_relative 'base_handler'

module TestSteps
  module Handlers
    class InsertValueConfig < Base
      register :insert_value_config

      def perform(step_attributes)
        box = step_attributes[:testvalue]
        locate = step_attributes[:locate]
        value = step_attributes[:testvalue2]
        value = ENV[value.to_s]

        Browser.b.text_field(:"#{locate}" => box).wait_until.set value
        (Browser.b.text_field(:"#{locate}" => box).value == value)
        Report.results.puts("Textbox: #{box} has correct value: #{value}")
        true
      rescue StandardError
        Report.results.puts("Textbox: #{box} has the incorrect value: #{value}")
        false
      rescue StandardError
        Report.results.puts("Textbox: #{box} does not exist")
        false
      end
    end
  end
end