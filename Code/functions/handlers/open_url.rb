require_relative 'base_handler'

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
          MyLog.log.info("Opened URL: #{url}")
          return true
        else
          MyLog.log.warn("URL not open: #{url} - opened #{url_nme} instead")
          return false
        end
      end
    end
  end
end
