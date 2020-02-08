# frozen_string_literal: true

module Taf
  module TestSteps
    module Handlers
      # Open URL function.
      class OpenUrl < Base
        register :open_url

        def perform
          url = if ENV[@value]
                  ENV[@value.to_s]
                else
                  @value
                end
          Taf::Browser.b.navigate.to(url)
          true
        end
      end
    end
  end
end
