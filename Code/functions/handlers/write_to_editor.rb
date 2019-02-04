require_relative 'base_handler'

module TestSteps
  module Handlers
    class WriteToEditor < Base
      register :write_to_editor

      def perform(step_attributes)
        iframe = step_attributes[:testvalue]
        value = step_attributes[:testvalue2]
        locate = step_attributes[:locate]

        Browser.b.iframe(:"#{locate}" => iframe).wait_until
        Browser.b.iframe(:"#{locate}" => iframe).send_keys value
        MyLog.log.info("Editor box: #{iframe} has correct value: #{value}")
        true
      rescue StandardError
        MyLog.log.warn("Editor box: #{iframe} has wrong value: #{value}")
        false
      rescue StandardError
        MyLog.log.warn("Editor box: #{iframe} does not exist")
        false
      end
    end
  end
end