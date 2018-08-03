# frozen_string_literal: true

# Created on 17 Oct 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# custom_functions.rb - for Portal use only.
# Please note these are custom functions.
module CustomFuncs
  require './taf_config.rb'

  # Portal login function.
  def self.login(value)
    url = ENV['URL']
    user = ENV[value.to_s]
    pass = ENV['USER_PASS']
    Browser.open_browser
    $browser.goto(url)
    url_name = $browser.url
    if url_name == url
      $results_file.write("opened URL: #{url} \n")
      if $browser.title.eql?('Log in')
        $browser.text_field(id: 'user_email').wait_until_present.set user
        $browser.text_field(id: 'user_password').wait_until_present.set pass
        $browser.button(value: 'Sign in').wait_until_present.click
        sleep 3
        if $browser.title.eql?('Memorable word')
        portal_mem_word()
        elsif  $browser.title.eql?('Home')
          $results_file.write("User: #{user} has logged in successful. \n")
          return true
        else
          $results_file.write("User: #{user} has failed to log in. \n")
          return false
        end
      end
    end
  end

    # Portal login with mem word function.
    def self.portal_mem_word
      password = ENV['USER_MEM']

      if $browser.title.eql?('Memorable word')
        nums = (1..256).to_a
        found_mem_nums = nums.each_with_object([]) do |num_val, mem_word|
          element_id = "user_memorable_parts_#{num_val}"
          mem_word.push(num_val) if $browser.select(:id => element_id).exist?
        end.compact

        array_password = password.split('')
        array_password.map!(&:upcase)

        found_mem_nums.each { |mem_num|
          char = array_password[(mem_num-1)]
          element_id = "user_memorable_parts_#{mem_num}"
          $browser.select_list(:id => element_id).option(:value => "#{char}").select
        }

        $browser.button(value: 'Sign in').wait_until_present.click
        return true
        if $browser.title.eql?('Home')
          $results_file.write("User: #{user} has logged in successful. \n")
          return true
        else
          $results_file.write("User: #{user} has failed to log in. \n")
          return false
        end
      end
    end

  # insert insert value from ENV variable.
  def self.insert_value_config(box, value, locate)
    value = ENV[value.to_s]
    $browser.text_field(:"#{locate}" => box).wait_until_present.set value
    ($browser.text_field(:"#{locate}" => box).value == value)
    $results_file.write("Text box: #{box} has correct value: #{value} \n")
    true
  rescue StandardError
    $results_file.write("Text box: #{box} has the incorrect value: #{value} \n")
    false
  rescue StandardError
    $results_file.write("Text box: #{box} does not exist \n")
    false
    # insert value from config function.
  end

  # open_portal_url from ENV variable.
  def self.open_portal_url(value)
    url = ENV[value.to_s]
    Browser.open_browser
    $browser.goto(url)
    url_nme = $browser.url
    if url_nme == url
      $results_file.write("opened URL: #{url} \n")
      return true
    else
      $results_file.write("URL not open: #{url} - opened #{url_nme} instead \n")
      return false
    end
  end
end
