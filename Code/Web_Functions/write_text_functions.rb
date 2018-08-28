# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# write_text_functions.rb - list of all Write text box functions.
module WriteTextFunctions
  require './taf_config.rb'
  # Write text box function.
  def self.write_text(box, value, locate)
    # two parameters: box, value
    found_box = [
      Browser.b.textarea(:"#{locate}" => box).exist?,
      Browser.b.text_field(:"#{locate}" => box).exist?
    ]

    raise 'Multiple matches' if found_box.select { |i| i }.empty?
    index = found_box.index(true)
    return unless index
    if index.zero?
      Browser.b.textarea(:"#{locate}" => box).wait_until_present.set value
      (Browser.b.textarea(:"#{locate}" => box).value == value)
    elsif index == 1
      Browser.b.text_field(:"#{locate}" => box).wait_until_present.set value
      (Browser.b.text_field(:"#{locate}" => box).value == value)
    end
    Report.results.write("Textbox: #{box} has correct value: #{value} \n")
    true
  rescue StandardError
    Report.results.write("Textbox: #{box} has the incorrect value: #{value} \n")
    false
  rescue StandardError
    Report.results.write("Textbox: #{box} does not exist \n")
    false
  end

  # write to editor Function.
  def self.write_to_editor(iframe, locate, value)
    Browser.b.iframe(:"#{locate}" => iframe).wait_until_present
    Browser.b.iframe(:"#{locate}" => iframe).send_keys value
    Report.results.write("Editor box: #{iframe} has correct value: #{value} \n")
    true
  rescue StandardError
    Report.results.write("Editor box: #{iframe} has wrong value: #{value} \n")
    false
  rescue StandardError
    Report.results.write("Editor box: #{iframe} does not exist \n")
    false
  end
end
