# frozen_string_literal: true

module Taf
  module TestSteps
    # steps.rb - methods for collecting steps info for tap report file.
    class Step
      attr_reader :index, :description

      def initialize(
        index:,
        description:
      )
        @index = index
        @description = description
      end
    end
  end
end
