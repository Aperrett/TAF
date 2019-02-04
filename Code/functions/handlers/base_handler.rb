module TestSteps
  require_relative '../../taf_config.rb'
  module Handlers
    class Base
      def self.register(name)
        TestSteps.handlers[name.to_s] = self
      end

      def self.perform(*args)
        new.perform(*args)
      end

      def open_url_process(url)
        Browser.open_browser
        Browser.b.goto(url)
      end

      def login_process(b_title, user_elm, pass_elm, user, pass)
        if Browser.b.title.eql?(b_title)
          Browser.b.text_field(id: user_elm).wait_until.set user
          Browser.b.text_field(id: pass_elm).wait_until.set pass
          login_button
          sleep 3
        else
          MyLog.log.warn("User: #{user} has failed to log in.")
        end
      end

      def login_button
        if Browser.b.button(value: 'Sign in').exist?
          Browser.b.button(value: 'Sign in').wait_until.click
        elsif Browser.b.button(value: 'Log in').exist?
          Browser.b.button(value: 'Log in').wait_until.click
        else
          MyLog.log.warn("User: #{user} has failed to log in.")
        end
      end

      def login_check(b_title_sucess, user)
        if Browser.b.title.eql?(b_title_sucess)
          MyLog.log.info("User: #{user} has logged in successful.")
          true
        else
          MyLog.log.warn("User: #{user} has failed to log in.")
          false
        end
      end

      def mem_word_check(user, b_title_sucess)
        if Browser.b.title.eql?('Memorable word - UKCloud Portal')
          portal_mem_word(user, b_title_sucess)
        elsif Browser.b.title.eql?(b_title_sucess)
          MyLog.log.info("User: #{user} has logged in successful.")
          true
        else
          MyLog.log.warn("User: #{user} has failed to log in.")
          false
        end
      end

      def portal_mem_word(user, b_title_sucess)
        password = ENV['PORTAL_MEM']
        nums = (1..256).to_a
        found_mem_nums = nums.each_with_object([]) do |num_val, mem_word|
        elm_id = "user_memorable_parts_#{num_val}"
        mem_word.push(num_val) if Browser.b.select(:id => elm_id).exist?
        end.compact

        array_password = password.split('')
        array_password.map!(&:upcase)

        found_mem_nums.each { |mem_num|
        char = array_password[(mem_num-1)]
        elm_id = "user_memorable_parts_#{mem_num}"
        Browser.b.select_list(:id => elm_id).option(:value => "#{char}").select
        }

        Browser.b.button(value: 'Sign in').wait_until.click
        if Browser.b.title.eql?(b_title_sucess)
          MyLog.log.info("User: #{user} has logged in successful.")
          return true
        else
          MyLog.log.warn("User: #{user} has failed to log in.")
          return false
        end
      end
    end 
  end
end