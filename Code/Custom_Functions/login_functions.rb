# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# login_functions.rb - List of Portal login functions.
# Please note these are custom functions for login use only.
module LoginFunctions
  require './taf_config.rb'
  # login function.
  def self.login(value)
    url = ENV['URL']
    user = ENV[value.to_s]
    pass = ENV['USER_PASS']
    Browser.open_browser
    Browser.b.goto(url)
    url_name = Browser.b.url
    if url_name == url
      Report.results.write("opened URL: #{url} \n")
      if Browser.b.title.eql?('Log in')
        Browser.b.text_field(id: 'user_email').wait_until_present.set user
        Browser.b.text_field(id: 'user_password').wait_until_present.set pass
        Browser.b.button(value: 'Sign in').wait_until_present.click
        sleep 3
        if Browser.b.title.eql?('Memorable word')
          CustomMiscFunctions.portal_mem_word
        elsif Browser.b.title.eql?('Home')
          Report.results.write("User: #{user} has logged in successful. \n")
          return true
        else
          Report.results.write("User: #{user} has failed to log in. \n")
          return false
        end
      end
    end
  end
end
