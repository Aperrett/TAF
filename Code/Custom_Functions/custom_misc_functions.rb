# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# custom_misc_functions.rb - insert insert value from ENV variable.
# Please note these are custom functions for Portal use only.
module CustomMiscFunctions
  require './taf_config.rb'
  # insert insert value from ENV variable.
  def self.insert_value_config(box, value, locate)
    value = ENV[value.to_s]
    Browser.b.text_field(:"#{locate}" => box).wait_until_present.set value
    (Browser.b.text_field(:"#{locate}" => box).value == value)
    Report.results.write("Textbox: #{box} has correct value: #{value} \n")
    true
  rescue StandardError
    Report.results.write("Textbox: #{box} has the incorrect value: #{value} \n")
    false
  rescue StandardError
    Report.results.write("Textbox: #{box} does not exist \n")
    false
  end

  # open_portal_url from ENV variable.
  def self.open_portal_url(value)
    url = ENV[value.to_s]
    Browser.open_browser
    Browser.b.goto(url)
    url_nme = Browser.b.url
    if url_nme == url
      Report.results.write("opened URL: #{url} \n")
      return true
    else
      Report.results.write("URL not open: #{url} - opened #{url_nme} instead\n")
      return false
    end
  end

  # Mem word for login
  def self.portal_mem_word
    password = ENV['PORTAL_MEM']

    if Browser.b.title.eql?('Memorable word')
      nums = (1..256).to_a
      found_mem_nums = nums.each_with_object([]) do |num_val, mem_word|
        elm_id = "user_memorable_parts_#{num_val}"
        mem_word.push(num_val) if Browser.b.select(:id => elm_id).exist?
      end.compact

      array_password = password.split('')
      array_password.map!(&:upcase)

      found_mem_nums.each { |mem_num|
        char = array_password[(mem_num-1)]
        elm_id = "user_memorable_parts_#{mem_num}"
        Browser.b.select_list(:id => elm_id).option(:value => "#{char}").select
      }

      Browser.b.button(value: 'Sign in').wait_until_present.click
      return true
      if Browser.b.title.eql?('Home')
        Report.results.write("User: #{user} has logged in successful. \n")
        return true
      else
        Report.results.write("User: #{user} has failed to log in. \n")
        return false
      end
    end
  end
end
