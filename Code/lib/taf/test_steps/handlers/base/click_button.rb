# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Click Button function.
      class ClickButton < Base
        register :click_button

        def check
          @elms = %i[button span a div link image h1 h2 h3 h4]

          found_button = @elms.map do |elm|
            Taf::Browser.b.send(elm, "#{@locate}": @value).exists?
          end.compact

          raise 'Multiple matches' if found_button.select { |i| i }.empty?

          index = found_button.index(true)
          return unless index

          index
        end

        def perform
          index = check
          Taf::Browser.b.send(@elms[index], "#{@locate}": @value)
                      .wait_until(&:exists?).click
          Taf::MyLog.log.info("Button: #{@value} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Button: #{@value} does not exist")
          false
        end
      end
    end
  end
end
