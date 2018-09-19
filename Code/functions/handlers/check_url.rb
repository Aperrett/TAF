require_relative 'base_handler'
require './taf_config.rb'

module TestSteps
  module Handlers
    class CheckUrl < Base
      register :check_url

      def perform(step_attributes)
        url = step_attributes[:testvalue]

        if Browser.b.url == url
          Report.results.puts("URL: #{url} is correct")
          true
        else
          Report.results.puts("URL: #{url} is incorrect")
          false
        end
      end
    end
  end
end