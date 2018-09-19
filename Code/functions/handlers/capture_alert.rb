require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class CaptureAlert < Base
      register :capture_alert

      def perform(step_attributes)
        Browser.b.div(class: 'alert').exist?
        alertmsg = Browser.b.div(class: 'alert').text
        Report.results.puts("Alert shown: #{alertmsg}")
        true
      rescue StandardError
        Report.results.puts('No Alert Found')
        false
      end
    end
  end
end