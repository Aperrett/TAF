# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    class WriteBoxdata < Base
      register :write_box_data

      def perform(step_attributes)
        box = step_attributes[:testvalue]
        value = step_attributes[:testvalue2]
        locate = step_attributes[:locate]

        text = ENV[value.to_s] || step_attributes[:testvalue2]
        WriteBoxdata.input_value(box, text, locate)
      end

      def self.input_value(box, text, locate)
        found_box = [
          Browser.b.textarea("#{locate}": box).exist?,
          Browser.b.text_field("#{locate}": box).exist?,
          Browser.b.iframe("#{locate}": box).exist?
        ]

        raise 'Multiple matches' if found_box.select { |i| i }.empty?

        index = found_box.index(true)
        return unless index

        if index.zero?
          Browser.b.textarea("#{locate}": box).wait_until(&:exists?).set text
          (Browser.b.textarea("#{locate}": box).text == text)
        elsif index == 1
          Browser.b.text_field("#{locate}": box).wait_until(&:exists?).set text
          (Browser.b.text_field("#{locate}": box).text == text)
        elsif index == 2
          Browser.b.iframe("#{locate}": box).wait_until(&:exists?).send_keys text
        end
        MyLog.log.info("Textbox: #{box} has correct value: #{text}")
        true
      rescue StandardError
        MyLog.log.warn("Textbox: #{box} has the incorrect value: #{text}")
        false
      rescue StandardError
        MyLog.log.warn("Textbox: #{box} does not exist")
        false
      end
    end
  end
end
