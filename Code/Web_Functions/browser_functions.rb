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
    Report.results.write('Browser navigated back', "\n")
    true
  rescue StandardError
    Report.results.write('Browser failed to navigate back', "\n")
    false
  end

  # Browser Forward function.
  def self.browser_forward
    Browser.b.forward
    Report.results.write('Browser navigated forward', "\n")
    true
  rescue StandardError
    Report.results.write('Browser failed to navigate forward', "\n")
    false
  end

  # Browser Quit function.
  def self.browser_quit
    Browser.b.quit
    Report.results.write('Browser has closed successfully', "\n")
    true
  rescue StandardError
    Report.results.write('Browser has failed to close', "\n")
    false
  end

  # Browser Refresh function.
  def self.browser_refresh
    Browser.b.refresh
    Report.results.write('The Browser has been refreshed', "\n")
    true
  rescue StandardError
    Report.results.write('The Browser failed to refresh', "\n")
    false
  end
end
