# frozen_string_literal: true

module Taf
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
          Taf::MyLog.log.error "unable to find login: #{@value}"
          raise Taf::LoginTypeFailed
        end

        def login_user(user)
          case @value.downcase
          when 'portal_login' then portal_login(user)
          when 'sso_login' then sso_login(user)
          else
            Taf::MyLog.log.error 'Not a valid Login'
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

          Taf::Browser.b.goto(url)
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

          Taf::Browser.b.goto(url)
          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_sucess, user)
        end
      end
    end
  end
end
