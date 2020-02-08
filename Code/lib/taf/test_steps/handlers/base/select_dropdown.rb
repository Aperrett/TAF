# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Select Dropdown function.
      class SelectDropdown < Base
        register :select_dropdown

        def perform
          element = Taf::Browser.b.find_element("#{@locate}": @value)
          select = Selenium::WebDriver::Support::Select.new(element)
          select.select_by(:text, @value2)
          Taf::MyLog.log.info("Dropdown item: #{@value2} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Dropdown item: #{@value2} has NOT been selected")
          false
        end
      end
    end
  end
end
