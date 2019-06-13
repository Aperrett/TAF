# frozen_string_literal: true

# Created on 13 June 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#

module Taf
  # tap_report.rb - methods for outputting to a tap report file.
  class TapReport
    include Singleton

    def self.success(filename, index, description)
      step = Taf::TestSteps::SuccessStep.new(index: index,
                                             description: description)
      add_step filename, step
    end

    def self.failure(filename, index, description)
      step = Taf::TestSteps::FailureStep.new(index: index,
                                             description: description)
      add_step filename, step
    end

    def self.skip(filename, index, description)
      step = Taf::TestSteps::SkipStep.new(index: index,
                                          description: description)
      add_step filename, step
    end

    def self.add_step(filename, step)
      instance.tests[filename] ||= []
      instance.tests[filename] << step
    end

    def self.output
      project_id = Taf::JSONParser.project_id.delete(' ')
      ts_dir = File.join('Results', project_id)
      file = File.open("#{ts_dir}/report_#{SecureRandom.uuid}.tap", 'w')
      total_steps = 0
      successes = 0
      failures = 0
      instance.tests.each do |filename, steps|
        file.write("# #{filename}\n")
        steps.each do |step|
          total_steps += 1
          if step.is_a?(Taf::TestSteps::SkipStep)
            outstr = "ok #{total_steps} #{step.description} # SKIP"
          else
            if step.is_a?(Taf::TestSteps::SuccessStep)
              outstr = 'ok'
              successes += 1
            elsif step.is_a?(Taf::TestSteps::FailureStep)
              outstr = 'not ok'
              failures += 1
            else
              outstr = '# test error'
            end
            outstr += " #{total_steps} #{step.description} - Step #{step.index}"
          end

          file.write(outstr + "\n")
        end
      end
      file.write("1..#{total_steps}\n")
      file.write("# tests #{total_steps}\n")
      file.write("# pass #{successes}\n")
      file.write("# fail #{failures}\n")
      file.close
    end

    def initialize
      @tests = {}
    end

    attr_accessor :tests
  end
end
