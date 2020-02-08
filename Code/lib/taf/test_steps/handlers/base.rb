# frozen_string_literal: true

module Taf
  # Base Hanfer file to contain all shared login functions
  module TestSteps
    module Handlers
      # All Login functions function.
      class Base
        def initialize(step_attributes)
          @value =  step_attributes[:testvalue]
          @value2 = step_attributes[:testvalue2]
          @locate = step_attributes[:locate]
        end

        def self.register(name)
          TestSteps.handlers[name.to_s] = self
        end

        def self.perform(*args)
          new(*args).perform
        end

        def login_process(b_title, user_elm, pass_elm, user, pass)
          if Taf::Browser.b.title.eql? b_title
            Taf::Browser.b.find_element(id: user_elm).displayed?
            Taf::Browser.b.find_element(id: user_elm).send_keys user
            Taf::Browser.b.find_element(id: pass_elm).send_keys pass
            Taf::Browser.b.find_element(name: 'commit').click
            sleep 1
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
          end
        end

        def url_check(url)
          if Taf::Browser.b.current_url == url
            Taf::MyLog.log.info("URL: #{url} is correct.")
            true
          else
            Taf::MyLog.log.warn("URL: #{url} is incorrect.")
            false
          end
        end

        def login_check(b_title_success, user)
          if Taf::Browser.b.title.eql? b_title_success
            Taf::MyLog.log.info("User: #{user} has logged in successful.")
            true
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
            false
          end
        end
      end
    end
  end
end
