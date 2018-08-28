# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# click_functions.rb - list of Click function.
module ClickFunctions
  require './taf_config.rb'

  # Checkbox function.
  def self.check_box(checkbox, locate)
    Browser.b.checkbox(:"#{locate}" => checkbox).wait_until_present.click
    Report.results.write("Check box: #{checkbox} has been selected \n")
    true
  rescue StandardError
    Report.results.write("Check box: #{checkbox} does not exist \n")
    false
  end

  # Click button function.
  def self.click_button(button, locate)
    elms = %i{button span a div link image h1 h2 h3 h4}

    found_button = elms.map do |elm|
      Browser.b.send(elm, :"#{locate}" => button).exist?
    end.compact

    raise 'Multiple matches' if found_button.select { |i| i }.empty?
    index = found_button.index(true)
    return unless index

    case index
    when 0 then Browser.b.button(:"#{locate}" => button).wait_until_present.click
    when 1 then Browser.b.span(:"#{locate}" => button).wait_until_present.click
    when 2 then Browser.b.a(:"#{locate}" => button).wait_until_present.click
    when 3 then Browser.b.div(:"#{locate}" => button).wait_until_present.click
    when 4 then Browser.b.link(:"#{locate}" => button).wait_until_present.click
    when 5 then Browser.b.image(:"#{locate}" => button).wait_until_present.click
    when 6 then Browser.b.h1(:"#{locate}" => button).wait_until_present.click
    when 7 then Browser.b.h2(:"#{locate}" => button).wait_until_present.click
    when 8 then Browser.b.h3(:"#{locate}" => button).wait_until_present.click
    when 9 then Browser.b.h4(:"#{locate}" => button).wait_until_present.click
    end
    Report.results.write("Button: #{button} has been selected \n")
    true
  rescue StandardError
    Report.results.write("Button: #{button} does not exist \n")
    false
  end

  # Radio button function.
  def self.radio_button(radio, value2, locate, locate2)
    Browser.b.radio(:"#{locate}" => radio).wait_until_present
    Browser.b.radio(:"#{locate}" => radio, :"#{locate2}" => "#{value2}").set
    Report.results.write("Radio button: #{radio} has been selected \n")
    true
  rescue StandardError
    Report.results.write("Radio button: #{radio} does not exist \n")
    false
  end

  # Select Dropdown function.
  def self.select_dropdown(dropdown, value, locate, locate2)
    # two parameters: dropdown, value
    Browser.b.select_list(:"#{locate}" => dropdown).wait_until_present
    Browser.b.select_list(:"#{locate}" => dropdown).option(:"#{locate2}" => "#{value}").select
    Report.results.write("Dropdown item: #{value} has been selected \n")
    true
  rescue StandardError
    Report.results.write("Dropdown item: #{value} has NOT been selected \n")
    false
  rescue StandardError
    Report.results.write("the dropdown: #{dropdown} does not exist \n")
    false
  end
end
