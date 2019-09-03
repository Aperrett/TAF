# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Click Button function.
      class ClickButton < Base
        register :click_button

        def perform
          # Optimisation: if we can immediately find the target in the DOM
          # under a specific tag we should use it.
          @tag = %i[button span a div link image h1 h2 h3 h4].find do |e|
            Taf::Browser.b.send(e, "#{@locate}": @value).exists?
          end

          # Otherwise, fallback to locating across the entire DOM.
          # This can be necessary for when content rendering is deferred
          # (e.g., a loader in a SPA) or if the user wants to use CSS or XPath.
          @tag ||= :element

          Taf::Browser.b.send(@tag, "#{@locate}": @value).wait_until(&:exists?)
                      .click

          Taf::MyLog.log.info("Button: #{@value} has been selected")
          true
        rescue StandardError
          Taf::MyLog.log.warn("Button: #{@value} does not exist")
          false
        end
      end
    end
  end
end
