# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Radio Button function.
      class RadioButton < Base
        register :radio_button

        def perform
          Taf::Browser.b.radio("#{@locate}": @value).wait_until(&:exists?)
          Taf::Browser.b
                      .radio("#{@locate}": @value, "#{@locate2}": @value2.to_s)
                      .set
          Taf::MyLog.log.info("Radio button: #{@value2} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Radio button: #{@value2} does not exist")
          false
        end
      end
    end
  end
end
