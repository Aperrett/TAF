# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Write box data function.
      class WriteBoxdata < Base
        register :write_box_data

        def perform
          txt = @value2
          txt = ENV[txt.to_s] if ENV[txt.to_s]
          Taf::Browser.b.find_element("#{@locate}": @value).displayed?
          Taf::Browser.b.find_element("#{@locate}": @value).send_keys txt
          Taf::MyLog.log.info("Textbox: #{@value} has correct value: #{txt}")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Textbox: #{@value} does not exist")
          false
        end
      end
    end
  end
end
