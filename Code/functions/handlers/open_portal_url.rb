require_relative 'base_handler'

module TestSteps
  module Handlers
    class OpenPortalUrl < Base
      register :open_portal_url

      def perform(step_attributes)
        value = step_attributes[:testvalue]
        url = ENV[value.to_s]
        Browser.open_browser
        Browser.b.goto(url)
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