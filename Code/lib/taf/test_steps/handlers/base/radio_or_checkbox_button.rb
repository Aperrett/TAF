# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Radio or Checkbox Button function.
      class RadioCheckboxButton < Base
        register :radio_or_checkbox_button

        def perform
          Taf::Browser.b.find_element("#{@locate}": @value).click
          Taf::Browser.b.find_element("#{@locate}": @value).selected?
          Taf::MyLog.log.info("Check box / Radio: #{@value} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Check box / Radio: #{@value} does not exist")
          false
        end
      end
    end
  end
end
