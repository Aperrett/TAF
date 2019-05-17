# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # List all Dropdown Values function.
    class ListAllDropdownValues < Base
      register :list_all_dropdown_values

      def perform
        Browser.b.element("#{@locate}": @value).wait_until(&:exists?)
        Browser.b.select_list("#{@locate}": @value).options.each do |i|
          MyLog.log.info("List of dropdown for #{@value} are: #{i.text}")
          return true
        end
      rescue StandardError
        MyLog.log.warn("List dropdown: #{@value} does not exist")
        false
      end
    end
  end
end
