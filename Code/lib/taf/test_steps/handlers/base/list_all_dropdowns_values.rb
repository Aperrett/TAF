# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # List all Dropdown Values function.
      class ListAllDropdownValues < Base
        register :list_all_dropdown_values

        def perform
          Taf::Browser.b.element("#{@locate}": @value).wait_until(&:exists?)
          Taf::Browser.b.select_list("#{@locate}": @value).options.each do |i|
            Taf::MyLog.log.info("List of dropdown for #{@value} are: #{i.text}")
            return true
          end
        rescue StandardError
          Taf::MyLog.log.warn("List dropdown: #{@value} does not exist")
          false
        end
      end
    end
  end
end
