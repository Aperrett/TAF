# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Select Dropdown function.
    class SelectDropdown < Base
      register :select_dropdown

      def perform
        ele = Browser.b.select_list("#{@locate}": @value)

        ele.wait_until(&:exists?)
        ele.option("#{@locate2}": @value2.to_s).select
        MyLog.log.info("Dropdown item: #{@value2} has been selected")
        true
      rescue StandardError
        MyLog.log.warn("Dropdown item: #{@value2} has NOT been selected")
        false
      end
    end
  end
end
