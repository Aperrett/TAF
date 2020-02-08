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
        end

        def login_user(user)
          case @value.downcase
          when 'admin_portal_login' then admin_portal_login(user)
          when 'portal_login' then portal_login(user)
          when 'sint_login' then sint_login(user)
          when 'sso_login' then sso_login(user)
          else
            Taf::MyLog.log.error "unable to find login: #{@value}"
            raise Taf::LoginTypeFailed
          end
        end

        private

        def admin_portal_login(user)
          url = ENV['ADMINL_URL']
          pass = ENV['ADMIN_USER_PASS']
          b_title = 'Log in - UKCloud Portal Admin'
          b_title_success = 'Home - UKCloud Admin Portal'
          user_elm = 'admin_username'
          pass_elm = 'admin_password'

          Taf::Browser.b.navigate.to(url)
          url_check(url)
          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_success, user)
        end

        def portal_login(user)
          url = ENV['PORTAL_URL']
          pass = ENV['PORTAL_USER_PASS']
          b_title = 'Log in - UKCloud Portal'
          b_title_success = 'Home - UKCloud Portal'
          user_elm = 'user_email'
          pass_elm = 'user_password'

          Taf::Browser.b.navigate.to(url)
          url_check(url)
          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_success, user)
        end

        def sso_login(user)
          pass = ENV['SSO_USER_PASS']
          b_title = ''
          b_title_success = ''
          user_elm = 'username'
          pass_elm = 'password'

          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_success, user)
        end

        def sint_login(user)
          url = ENV['SINT_URL']
          pass = ENV['SINT_USER_PASS']
          b_title = 'SINT'
          b_title_success = 'SINT'
          user_elm = 'user_username'
          pass_elm = 'user_password'

          Taf::Browser.b.navigate.to(url)
          url_check(url)
          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_success, user)
        end
      end
    end
  end
end
