# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Click Button function.
      class ClickButton < Base
        register :click_button

        def perform
          if @locate['text']
            butt = Taf::Browser.b.find_element(xpath: "//*[text()='#{@value}']")
            butt.displayed?
            butt.click
            Taf::MyLog.log.info("Button: #{@value} has been selected")
            true
          else
            button = Taf::Browser.b.find_element("#{@locate}": @value)
            button.displayed?
            button.click
            Taf::MyLog.log.info("Button: #{@value} has been selected")
          end
        rescue StandardError
          Taf::MyLog.log.warn("Button: #{@value} does not exist")
          false
        end
      end
    end
  end
end
