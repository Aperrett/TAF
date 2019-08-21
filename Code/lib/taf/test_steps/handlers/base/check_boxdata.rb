# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Check Box Data function.
      class CheckBoxdata < Base
        register :check_box_data

        def check
          @elms = %i[textarea text_field iframe]

          found_box = @elms.map do |elm|
            Taf::Browser.b.send(elm, "#{@locate}": @value).exists?
          end.compact

          raise 'Multiple matches' if found_box.select { |i| i }.empty?

          index = found_box.index(true)
          return unless index

          index
        end

        def perform
          index = check
          ele = Taf::Browser.b.send(@elms[index], "#{@locate}": @value)

          ele.wait_until(&:exists?)

          if ele.value == @value2
            Taf::MyLog.log.info(
              "Textbox: #{@value} has correct value: #{@value2}"
            )
            true
          else
            Taf::MyLog.log.warn(
              "Textbox: got #{ele.value}, expected #{@value2}"
            )
            false
          end
        end
      end
    end
  end
end
