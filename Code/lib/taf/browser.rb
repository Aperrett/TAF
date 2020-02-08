# frozen_string_literal: true

# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # browser_setup.rb - a browser functions
  module Browser
    # Supported Browser names
    @chrome_name = 'chrome'
    @chrome_headless_name = 'chrome-headless'
    @firefox_name = 'firefox'
    @firefox_headless_name = 'firefox-headless'

    # open_browser function
    def self.open_browser
      @browser_name = Taf::CMDLine.browser_type.downcase
      case @browser_name
      when @chrome_name, @chrome_headless_name then chrome
      when @firefox_name, @firefox_headless_name then firefox
      else
        raise Taf::BrowserFailedOpen,
              "unable to open selected browser: #{@browser_name}"
      end
    end

    # chrome browser details
    def self.chrome
      case @browser_name
      when @chrome_name
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--window-size=1920,1080')
      when @chrome_headless_name
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--window-size=1920,1080')
      end
      @browser = Selenium::WebDriver.for :chrome, options: options
      @browser.manage.timeouts.implicit_wait = 120
    end

    # firefox browser details
    def self.firefox
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps['acceptInsecureCerts'] = true
      case @browser_name
      when @firefox_name
        @browser = Selenium::WebDriver.for(:firefox, desired_capabilities: caps)
      when @firefox_headless_name
        options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
        @browser = Selenium::WebDriver.for(:firefox, options: options,
                                                     desired_capabilities: caps)
      end
      @browser.manage.window.maximize
      @browser.manage.timeouts.implicit_wait = 120
    end

    # define browser value
    def self.b
      @browser
    end

    # Check browser version
    def self.browser_version
      case @browser_name
      when @chrome_name, @chrome_headless_name
        @browser.capabilities[:version]
      when @firefox_name, @firefox_headless_name
        @browser.execute_script('return navigator.userAgent;').split('/')[-1]
      else
        'No Browser version'
      end
    end

    # Check platform
    def self.browser_platform
      ptf = @browser.execute_script('return navigator.userAgent;').split(';')[1]

      case @browser_name
      when @chrome_name, @chrome_headless_name
        ptf.split(')')[0]
      when @firefox_name, @firefox_headless_name
        ptf
      else
        'No Platform found'
      end
    end
  end
end
