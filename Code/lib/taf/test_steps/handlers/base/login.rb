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
          when 'portal_login' then portal_login(user)
          when 'sso_login' then sso_login(user)
          else
            Taf::MyLog.log.error "unable to find login: #{@value}"
            raise Taf::LoginTypeFailed
          end
        end

        private

        def portal_login(user)
          url = ENV['PORTAL_URL']
          pass = ENV['PORTAL_USER_PASS']
          b_title = 'Log in'
          b_title_success = 'Home'
          memorable_word_title = 'Memorable word'
          user_elm = 'user_email'
          pass_elm = 'user_password'
          max_retry = 2

          max_retry.times do
            Taf::Browser.b.goto(url)
            url_check(url)
            login_process(b_title, user_elm, pass_elm, user, pass)

            begin
              Taf::Browser.b.wait_until(timeout: 30) do |b|
                b.title == b_title_success || b.title == memorable_word_title
              end
            rescue Watir::Wait::TimeoutError
              Taf::MyLog.log.warn('Retrying login process...')
              next
            end

            success = true

            if Taf::Browser.b.title.eql?(memorable_word_title)
              success = portal_mem_word(user, b_title_success)
            end

            return success
          end

          false
        end

        def sso_login(user)
          pass = ENV['SSO_USER_PASS']
          b_title = ''
          b_title_success = ''
          user_elm = 'username'
          pass_elm = 'password'

          Taf::Browser.b.goto(url)
          url_check(url)
          login_process(b_title, user_elm, pass_elm, user, pass)
          login_check(b_title_success, user)
        end
      end
    end
  end
end
