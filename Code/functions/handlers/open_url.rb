require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class OpenUrl < Base
      register :open_url

      def perform(step_attributes)
        url = step_attributes[:testvalue]

        Browser.open_browser
        Browser.b.goto(url)
        sleep 2
        url_nme = Browser.b.url
        if url_nme == url
          Report.results.puts("opened URL: #{url}")
          return true
        else
          Report.results.puts("URL not open: #{url} - opened #{url_nme} instead")
          return false
        end
      end
    end
  end
end