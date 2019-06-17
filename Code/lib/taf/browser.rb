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
    # Suppoerted Browser names
    @chrome_name = 'chrome'
    @chrome_headless_name = 'chrome-headless'
    @firefox_name = 'firefox'
    @firefox_headless_name = 'firefox-headless'

    # open_browser function
    def self.open_browser
      browser = Taf::CMDLine.browser_type.downcase
      case browser
      when @chrome_name then chrome
      when @chrome_headless_name then chrome_headless
      when @firefox_name then firefox
      when @firefox_headless_name then firefox_headless
      else
        raise Taf::BrowserFailedOpen,
              "unable to open selected browser: #{browser}"
      end
    end

    # chrome browser details
    def self.chrome
      @browser = Watir::Browser.new :chrome, switches: %w[
        --acceptInsecureCerts-true --start-maximized --window-size=1920,1080
      ]
    end

    # chrome headless browser details
    def self.chrome_headless
      @browser = Watir::Browser.new :chrome, switches: %w[
        --start-maximized --disable-gpu --headless --acceptInsecureCerts-true
        --no-sandbox --window-size=1920,1080
      ]
    end

    # firefox browser details
    def self.firefox
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps['acceptInsecureCerts'] = true
      driver = Selenium::WebDriver.for(:firefox, desired_capabilities: caps)
      @browser = Watir::Browser.new(driver)
      browser_full_screen
    end

    # firefox headless browser details
    def self.firefox_headless
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
      caps['acceptInsecureCerts'] = true
      driver = Selenium::WebDriver.for(:firefox, options: options,
                                                 desired_capabilities: caps)
      @browser = Watir::Browser.new(driver)
      # makes the browser full screen.
      @browser.driver.manage.window.resize_to(1920, 1200)
      @browser.driver.manage.window.move_to(0, 0)
    end

    # makes the browser full screen.
    def self.browser_full_screen
      screen_width = @browser.execute_script('return screen.width;')
      screen_height = @browser.execute_script('return screen.height;')
      @browser.driver.manage.window.resize_to(screen_width, screen_height)
      @browser.driver.manage.window.move_to(0, 0)
    end

    # define browser value
    def self.b
      @browser
    end

    # Check browser version
    def self.browser_version
      browser_name = Taf::CMDLine.browser_type.downcase
      case browser_name
      when @chrome_name, @chrome_headless_name
        @browser.driver.capabilities[:version]
      when @firefox_name, @firefox_headless_name
        @browser.execute_script('return navigator.userAgent;').split('/')[-1]
      else
        'No Browser version'
      end
    end

    # Check platform
    def self.browser_platform
      browser_name = Taf::CMDLine.browser_type.downcase
      case browser_name
      when @chrome_name, @chrome_headless_name
        @browser.execute_script('return navigator.userAgent;')
                .split(';')[1].split(')')[0]
      when @firefox_name, @firefox_headless_name
        @browser.execute_script('return navigator.userAgent;').split(';')[1]
      else
        'No Platform found'
      end
    end
  end
end
