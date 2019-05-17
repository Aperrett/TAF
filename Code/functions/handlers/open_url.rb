# frozen_string_literal: true

require_relative 'base_handler'

module TestSteps
  module Handlers
    # Open URL function.
    class OpenUrl < Base
      register :open_url

      def perform
        Browser.open_browser

        url = if ENV[@value]
                ENV[@value.to_s]
              else
                @value
              end
        Browser.b.goto(url)
        OpenUrl.check_current_url(url)
      end

      def self.check_current_url(url)
        url_check = Browser.b.url
        if url_check == url
          MyLog.log.info("Opened URL: #{url}")
          return true
        else
          MyLog.log.warn("URL not open: #{url} - opened #{url_check} instead")
          return false
        end
      end
    end
  end
end
