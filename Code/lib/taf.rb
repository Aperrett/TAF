# frozen_string_literal: true

# Taf is the main namespace for this project.
module Taf
  class TafError < StandardError; end
  class UnknownTestStep < TafError; end
  class FailureThresholdExceeded < TafError; end
  class BrowserFailedOpen < TafError; end
  class LoginTypeFailed < TafError; end

  require 'selenium-webdriver'
  require 'watir'
  require 'rubygems'
  require 'fileutils'
  require 'logger'
  require 'net/ping'
  require 'time_difference'
  require 'colored'
  require 'optparse'
  require 'fileutils'
  require 'securerandom'
  require 'json'

  require 'taf/browser'
  require 'taf/cmd_line'
  require 'taf/create_directories'
  require 'taf/json_parser'
  require 'taf/tap_report'
  require 'taf/my_log'
  require 'taf/parser'
  require 'taf/report'
  require 'taf/report_summary'
  require 'taf/screenshot'
  require 'taf/test_engine'
  require 'taf/test_steps'
  require 'taf/test_steps/step'
  require 'taf/test_steps/success_step'
  require 'taf/test_steps/failure_step'
  require 'taf/test_steps/skip_step'
  require 'taf/test_steps/handlers/base'
  require 'taf/version'

  # Load all handlers.
  Dir[File.expand_path('taf/test_steps/handlers/base/*.rb', __dir__)]
    .each do |f|
    require f
  end

  # Watir config. set wait:
  Watir.default_timeout = 60
end
