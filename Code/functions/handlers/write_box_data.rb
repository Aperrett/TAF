# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Write box data function.
    class WriteBoxdata < Base
      register :write_box_data

      def perform(step_attributes)
        box = step_attributes[:testvalue]
        value = step_attributes[:testvalue2]
        locate = step_attributes[:locate]

        txt = ENV[value.to_s] || step_attributes[:testvalue2]
        WriteBoxdata.input_value(box, txt, locate)
      end

      def self.input_value(box, txt, locate)
        found_box = [
          Browser.b.textarea("#{locate}": box).exist?,
          Browser.b.text_field("#{locate}": box).exist?,
          Browser.b.iframe("#{locate}": box).exist?
        ]

        raise 'Multiple matches' if found_box.select { |i| i }.empty?

        index = found_box.index(true)
        return unless index

        if index.zero?
          Browser.b.textarea("#{locate}": box).wait_until(&:exists?).set txt
          (Browser.b.textarea("#{locate}": box).text == txt)
        elsif index == 1
          Browser.b.text_field("#{locate}": box).wait_until(&:exists?).set txt
          (Browser.b.text_field("#{locate}": box).text == txt)
        elsif index == 2
          Browser.b.iframe("#{locate}": box).wait_until(&:exists?).send_keys txt
        end
        MyLog.log.info("Textbox: #{box} has correct value: #{txt}")
        true
      rescue StandardError
        MyLog.log.warn("Textbox: #{box} has the incorrect value: #{txt}")
        false
      rescue StandardError
        MyLog.log.warn("Textbox: #{box} does not exist")
        false
      end
    end
  end
end
