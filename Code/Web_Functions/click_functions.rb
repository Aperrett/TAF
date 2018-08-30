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
    Report.results.puts("Check box: #{checkbox} has been selected")
    true
  rescue StandardError
    Report.results.puts("Check box: #{checkbox} does not exist")
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
    when 0
      Browser.b.button(:"#{locate}" => button).wait_until_present.click
    when 1
      Browser.b.span(:"#{locate}" => button).wait_until_present.click
    when 2
      Browser.b.a(:"#{locate}" => button).wait_until_present.click
    when 3
      Browser.b.div(:"#{locate}" => button).wait_until_present.click
    when 4
      Browser.b.link(:"#{locate}" => button).wait_until_present.click
    when 5
      Browser.b.image(:"#{locate}" => button).wait_until_present.click
    when 6
      Browser.b.h1(:"#{locate}" => button).wait_until_present.click
    when 7
      Browser.b.h2(:"#{locate}" => button).wait_until_present.click
    when 8
      Browser.b.h3(:"#{locate}" => button).wait_until_present.click
    when 9
      Browser.b.h4(:"#{locate}" => button).wait_until_present.click
    end
    Report.results.puts("Button: #{button} has been selected")
    true
  rescue StandardError
    Report.results.puts("Button: #{button} does not exist")
    false
  end

  # Radio button function.
  def self.radio_button(radio, value2, locate, locate2)
    Browser.b.radio(:"#{locate}" => radio).wait_until_present
    Browser.b.radio(:"#{locate}" => radio, :"#{locate2}" => "#{value2}").set
    Report.results.puts("Radio button: #{radio} has been selected")
    true
  rescue StandardError
    Report.results.puts("Radio button: #{radio} does not exist")
    false
  end

  # Select Dropdown function.
  def self.select_dropdown(dropdown, value, locate, locate2)
    # two parameters: dropdown, value
    Browser.b.select_list(:"#{locate}" => dropdown).wait_until_present
    Browser.b.select_list(:"#{locate}" => dropdown).option(:"#{locate2}" => "#{value}").select
    Report.results.puts("Dropdown item: #{value} has been selected")
    true
  rescue StandardError
    Report.results.puts("Dropdown item: #{value} has NOT been selected")
    false
  rescue StandardError
    Report.results.puts("the dropdown: #{dropdown} does not exist")
    false
  end
end
