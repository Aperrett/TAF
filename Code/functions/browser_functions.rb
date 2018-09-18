# frozen_string_literal: true

# Created on 22 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# browser_functions.rb - list of browser functions.
module BrowserFunctions
  require './taf_config.rb'
  # Browser Back function.
  def self.browser_back
    Browser.b.back
    Report.results.puts('Browser navigated back')
    true
  rescue StandardError
    Report.results.puts('Browser failed to navigate back')
    false
  end

  # Browser Forward function.
  def self.browser_forward
    Browser.b.forward
    Report.results.puts('Browser navigated forward')
    true
  rescue StandardError
    Report.results.puts('Browser failed to navigate forward')
    false
  end

  # Browser Quit function.
  def self.browser_quit
    Browser.b.quit
    Report.results.puts('Browser has closed successfully')
    true
  rescue StandardError
    Report.results.puts('Browser has failed to close')
    false
  end

  # Browser Refresh function.
  def self.browser_refresh
    Browser.b.refresh
    Report.results.puts('The Browser has been refreshed')
    true
  rescue StandardError
    Report.results.puts('The Browser failed to refresh')
    false
  end
end
