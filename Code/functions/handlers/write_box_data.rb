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

        elms = %i[textarea text_field iframe]

        found_box = elms.map do |elm|
          Browser.b.send(elm, "#{locate}": box).exists?
        end.compact

        raise 'Multiple matches' if found_box.select { |i| i }.empty?

        index = found_box.index(true)
        return unless index

        Browser.b.send(elms[index], "#{locate}": box)
               .wait_until(&:exists?).send_keys txt
        MyLog.log.info("Textbox: #{box} has correct value: #{txt}")
        true
      rescue StandardError
        MyLog.log.warn("Textbox: #{box} does not exist")
        false
      end
    end
  end
end
