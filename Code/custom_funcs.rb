# frozen_string_literal: true

# Created on 17 Oct 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# custom_functions.rb
# Please note these are custom functions.
module CustomFuncs
  require './taf_config.rb'

  # login function.
  def self.portal_login
    url = ENV['URL']
    user = ENV['USER_EMAIL']
    pass = ENV['USER_PASS']
    Utils.open_browser
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
        mem_word()
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

    # mem word function.
    def self.mem_word
      if $browser.title.eql?('Memorable word')
        nums = (1..256).to_a
        found_mem = nums.each_with_object([]) do |num, memo|
          id = "user_memorable_parts_#{num}"
          memo.push(num) if $browser.select(:id => id).exist?
        end.compact

        found_mem.each { |x|
          id = "user_memorable_parts_#{x}"
          $browser.select_list(:id => id).option(:text => "#{x}").select
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

  # open_web_url from ENV variable.
  def self.open_web_url(value)
    url = ENV[value.to_s]
    Utils.open_browser
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
