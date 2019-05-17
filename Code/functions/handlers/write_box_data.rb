# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Write box data function.
    class WriteBoxdata < Base
      register :write_box_data

      def perform
        txt = @value2
        txt = ENV[txt.to_s] if ENV[txt.to_s]
        elms = %i[textarea text_field iframe]

        found_box = elms.map do |elm|
          Browser.b.send(elm, "#{@locate}": @value).exists?
        end.compact

        raise 'Multiple matches' if found_box.select { |i| i }.empty?

        index = found_box.index(true)
        return unless index

        Browser.b.send(elms[index], "#{@locate}": @value)
               .wait_until(&:exists?).send_keys txt
        MyLog.log.info("Textbox: #{@value} has correct value: #{txt}")
        true
      rescue StandardError
        MyLog.log.warn("Textbox: #{@value} does not exist")
        false
      end
    end
  end
end
