require_relative 'base_handler'

module TestSteps
  module Handlers
    class Login < Base
      register :login

      def perform(step_attributes)
        login_type = step_attributes[:testvalue]
        user = step_attributes[:testvalue2]
        user = ENV[user.to_s] if ENV[user.to_s]

        lc_login_type = login_type.downcase
        case lc_login_type
        when 'portal_login'
          portal_login(user)
        when 'sso_login'
          sso_login(user)
        else
          MyLog.log.error "unable to find login: #{lc_login_type}"
          raise LoginTypeFailed
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
