# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Click Button function.
    class ClickButton < Base
      register :click_button

      def perform(step_attributes)
        button = step_attributes[:testvalue]
        locate = step_attributes[:locate]

        elms = %i[button span a div link image h1 h2 h3 h4]

        found_button = elms.map do |elm|
          Browser.b.send(elm, "#{locate}": button).exists?
        end.compact

        raise 'Multiple matches' if found_button.select { |i| i }.empty?

        index = found_button.index(true)
        return unless index

        Browser.b.send(elms[index], "#{locate}": button)
               .wait_until(&:exists?).click
        MyLog.log.info("Button: #{button} has been selected")
        true
      rescue StandardError
        MyLog.log.warn("Button: #{button} does not exist")
        false
      end
    end
  end
end
