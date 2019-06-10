# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Select Dropdown function.
      class SelectDropdown < Base
        register :select_dropdown

        def perform
          ele = Taf::Browser.b.select_list("#{@locate}": @value)

          ele.wait_until(&:exists?)
          ele.option("#{@locate2}": @value2.to_s).select
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
