# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check Box function.
      class CheckBox < Base
        register :check_box

        def perform
          Taf::Browser.b.checkbox("#{@locate}": @value).wait_until(&:exists?)
                      .click
          Taf::MyLog.log.info("Check box: #{@value} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Check box: #{@value} does not exist")
          false
        end
      end
    end
  end
end
