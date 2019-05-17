# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Radio Button function.
    class RadioButton < Base
      register :radio_button

      def perform
        Browser.b.radio("#{@locate}": @value).wait_until(&:exists?)
        Browser.b.radio("#{@locate}": @value, "#{@locate2}": @value2.to_s).set
        MyLog.log.info("Radio button: #{@value2} has been selected")
        true
      rescue StandardError
        MyLog.log.warn("Radio button: #{@value2} does not exist")
        false
      end
    end
  end
end
