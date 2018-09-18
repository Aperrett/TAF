# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# logins.rb - List of logins.
# Please note these are custom functions for login use only.
module Logins
  require './taf_config.rb'
  # Portal login function.
  def self.login(value)
    url = ENV['APP_URL']
    user = ENV[value.to_s]
    pass = ENV['APP_USER_PASS']
    b_title = 'Log in'
    b_title_sucess = 'Home'
    user_elm = 'user_email'
    pass_elm = 'user_password'
    LoginFunctions.open_url_process(url)
    LoginFunctions.login_process(b_title, user_elm, pass_elm, user, pass)
    LoginFunctions.mem_word_check(user, b_title_sucess)
  end
end
