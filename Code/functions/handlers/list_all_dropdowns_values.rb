require_relative 'base_handler'

module TestSteps
  module Handlers
    class ListAllDropdownValues < Base
      register :list_all_dropdown_values

      def perform(step_attributes)
        dropdown = step_attributes[:testvalue]
        locate = step_attributes[:locate]

        Browser.b.element("#{locate}": dropdown).wait_until(&:exists?)
        Browser.b.select_list("#{locate}": dropdown).options.each do |i|
          MyLog.log.info("List of dropdown for #{dropdown} are: #{i.text}")
          return true
        end
      rescue StandardError
        MyLog.log.warn("List dropdown: #{dropdown} does not exist")
        false
      end
    end
  end
end
