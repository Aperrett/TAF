require_relative 'base_handler'

module TestSteps
  module Handlers
    class PortalLogin < Base
      register :portal_login

      def perform(step_attributes)
        value = step_attributes[:testvalue]

        url = ENV['PORTAL_URL']
        user = ENV[value.to_s]
        pass = ENV['PORTAL_USER_PASS']
        b_title = 'Log in'
        b_title_sucess = 'Home'
        user_elm = 'user_email'
        pass_elm = 'user_password'
        
        open_url_process(url)
        login_process(b_title, user_elm, pass_elm, user, pass)
        mem_word_check(user, b_title_sucess)
      end
    end
  end
end