# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Radio Button function.
      class RadioButton < Base
        register :radio_button

        def perform
          Taf::Browser.b.radio("#{@locate}": @value).wait_until(&:exists?).set
          Taf::MyLog.log.info("Radio button: #{@value} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Radio button: #{@value} does not exist")
          false
        end
      end
    end
  end
end
