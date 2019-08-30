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
          if Taf::Browser.b.title.eql?(b_title)
            Taf::Browser.b.text_field(id: user_elm).wait_until(&:exists?)
                        .set user
            Taf::Browser.b.text_field(id: pass_elm).set pass
            button = 'Sign in' || 'Log in'
            Taf::Browser.b.button(value: button).wait_until(&:exists?).click
            sleep 1
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
          end
        end

        def login_check(b_title_sucess, user)
          if Taf::Browser.b.title.eql?(b_title_sucess)
            Taf::MyLog.log.info("User: #{user} has logged in successful.")
            true
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
            false
          end
        end

        def mem_word_check(user, b_title_sucess)
          if Taf::Browser.b.title.eql?('Memorable word')
            portal_mem_word(user, b_title_sucess)
          elsif Taf::Browser.b.title.eql?(b_title_sucess)
            Taf::MyLog.log.info("User: #{user} has logged in successful.")
            true
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
            false
          end
        end

        def portal_mem_word(user, b_title_sucess)
          password = ENV['PORTAL_MEM']
          nums = (1..256).to_a
          found_mem_nums = nums.each_with_object([]) do |num_val, mem_word|
            elm_id = "user_memorable_parts_#{num_val}"
            mem_word.push(num_val) if Taf::Browser.b.select(id: elm_id).exist?
          end.compact

          array_password = password.split('')
          array_password.map!(&:upcase)

          found_mem_nums.each do |mem_num|
            char = array_password[(mem_num - 1)]
            elm_id = "user_memorable_parts_#{mem_num}"
            Taf::Browser.b.select_list(id: elm_id).option(value: char.to_s)
                        .select
          end

          Taf::Browser.b.button(value: 'Sign in').wait_until(&:exists?).click
          if Taf::Browser.b.title.eql?(b_title_sucess)
            Taf::MyLog.log.info("User: #{user} has logged in successful.")
            return true
          else
            Taf::MyLog.log.warn("User: #{user} has failed to log in.")
            return false
          end
        end
      end
    end
  end
end
