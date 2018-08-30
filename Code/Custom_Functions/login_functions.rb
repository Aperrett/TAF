# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# login_functions.rb - List of login functions.
# Please note these are custom functions for login use only.
module LoginFunctions
  require './taf_config.rb'
  # open browser to url function.
  def self.open_url_process(url)
    Browser.open_browser
    Browser.b.goto(url)
  end

  # login process function.
  def self.login_process(b_title, user_elm, pass_elm, user, pass)
    if Browser.b.title.eql?(b_title)
      Browser.b.text_field(id: user_elm).wait_until_present.set user
      Browser.b.text_field(id: pass_elm).wait_until_present.set pass
      Browser.b.button(value: 'Sign in').wait_until_present.click
      sleep 3
    else
      Report.results.puts("User: #{user} has failed to log in.")
    end
  end

  # login check function.
  def self.login_check(b_title_sucess, user)
    if Browser.b.title.eql?(b_title_sucess)
      Report.results.puts("User: #{user} has logged in successful.")
      true
    else
      Report.results.puts("User: #{user} has failed to log in.")
      false
    end
  end

  # Check memorable word for login
  def self.mem_word_check(user, b_title_sucess)
    if Browser.b.title.eql?('Memorable word')
      CustomMiscFunctions.portal_mem_word
    elsif Browser.b.title.eql?(b_title_sucess)
      Report.results.puts("User: #{user} has logged in successful.")
      true
    else
      Report.results.puts("User: #{user} has failed to log in.")
      false
    end
  end

  # Portal login function.
  def self.login(value)
    url = ENV['URL']
    user = ENV[value.to_s]
    pass = ENV['USER_PASS']
    b_title = 'Log in'
    b_title_sucess = 'Home'
    user_elm = 'user_email'
    pass_elm = 'user_password'
    LoginFunctions.open_url_process(url)
    LoginFunctions.login_process(b_title, user_elm, pass_elm, user, pass)
    LoginFunctions.mem_word_check(user, b_title_sucess)
  end
end
