# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# check_functions.rb - list of checking functions.
module CheckFunctions
  require './taf_config.rb'

  # Checkbox data function.
  def self.check_boxdata(box, value, locate)
    # two parameters: box, value
    found_box = [
      Browser.b.textarea(:"#{locate}" => box).exist?,
      Browser.b.text_field(:"#{locate}" => box).exist?
    ]

    raise 'Multiple matches' if found_box.select { |i| i }.empty?
    index = found_box.index(true)
    return unless index
    if index.zero?
      Browser.b.textarea(:"#{locate}" => box).wait_until_present
      (Browser.b.textarea(:"#{locate}" => box).value == value)
    elsif index == 1
      Browser.b.text_field(:"#{locate}" => box).wait_until_present
      (Browser.b.text_field(:"#{locate}" => box).value == value)
    end
    Report.results.puts("Textbox: #{box} has the correct value: #{value}")
    true
  rescue StandardError
    Report.results.puts("Textbox: #{box} has the incorrect value: #{value}")
    false
  rescue StandardError
    Report.results.puts("Textbox: #{box} does not exist")
    false
  end

  # checkLogFile(text, file, output) - Pipe evidence to a file
  def self.check_logs(text, file, output)
    blog_result = system 'egrep -i ' + text + ' ' + file + ' > ' + output
    if blog_result == true
      Report.results.puts("Data has matched: #{text} in LogFile: #{file}")
      return true
    else
      Report.results.puts("Problem finding: #{text} in LogFile: #{file}")
      return false
    end
  end

  # check screen data function.
  def self.check_screendata(text_check)
    # one parameter: text value to check if text is displayed on page.
    sleep 5
    if Browser.b.text.include?(text_check)
      Report.results.puts("Found text: #{text_check}")
      return true
    else
      Report.results.puts("NOT found text: #{text_check}")
      return false
    end
  end

  # check browser title function.
  def self.check_title(text_check)
    sleep 2
    # one parameter: text value to check if browser title is correct.
    if Browser.b.title.eql?(text_check)
      Report.results.puts("Browser title: #{text_check}")
      return true
    else
      Report.results.puts("Title not found: #{text_check}")
      return false
    end
  end

  # Check URL function.
  def self.check_url(url)
    if Browser.b.url == url
      Report.results.puts("URL: #{url} is correct")
      true
    else
      Report.results.puts("URL: #{url} is incorrect")
      false
    end
  end

  # list All Dropdown Values function.
  def self.list_dropdowns(dropdown, locate)
    # print out the available dropdown selections
    Browser.b.element(:"#{locate}" => dropdown).wait_until_present
    Browser.b.select_list(:"#{locate}" => dropdown).options.each do |i|
      Report.results.puts("List of dropdown for #{dropdown} are: #{i.text}")
      return true
    end
  rescue StandardError
    Report.results.puts("List dropdown: #{dropdown} does not exist")
    false
  end
end
