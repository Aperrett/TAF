# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Logins function.
    class Login < Base
      register :login

      def perform
        user = @value2
        user = ENV[user.to_s] if ENV[user.to_s]

        login_user(user)
      rescue StandardError
        MyLog.log.error "unable to find login: #{@value}"
        raise LoginTypeFailed
      end

      def login_user(user)
        case @value.downcase
        when 'portal_login'
          portal_login(user)
        when 'sso_login'
          sso_login(user)
        end
      end

      private

      def portal_login(user)
        url = ENV['PORTAL_URL']
        pass = ENV['PORTAL_USER_PASS']
        b_title = 'Log in'
        b_title_sucess = 'Home'
        user_elm = 'user_email'
        pass_elm = 'user_password'

        open_url_process(url)
        login_process(b_title, user_elm, pass_elm, user, pass)
        mem_word_check(user, b_title_sucess)
      end

      def sso_login(user)
        pass = ENV['SSO_USER_PASS']
        # b_title = 'Log in to rh-sso'
        # b_title_sucess = 'RHS-SSO Admin Console'
        b_title = ''
        b_title_sucess = ''
        user_elm = 'username'
        pass_elm = 'password'

        login_process(b_title, user_elm, pass_elm, user, pass)
        login_check(b_title_sucess, user)
      end
    end
  end
end
