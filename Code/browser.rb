# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# browser_setup.rb - a browser functions
module Browser
  require './taf_config.rb'
  # open_browser function
  def self.open_browser
    lc_browser_type = $browserType.downcase
    case lc_browser_type
    when 'chrome'
      chrome
    when 'chrome-Headless'
      chrome_headless
    when 'firefox'
      firefox
    when 'firefox-headless'
      firefox_headless
    when 'ie'
      ie
    when 'safari'
      safari
    else
      puts "unable to open selected browser: #{lc_browser_type}"
      raise BrowserFailedOpen
    end
  rescue BrowserFailedOpen => error
    # construct the error message from custom text and the actual system error
    # message (converted to a string)
    error_text = "Unable to open"\
                  "the requested browser: #{lc_browser_type} " + error.to_s
    raise error_text
  end

  # chrome browser details
  def self.chrome
    @browser = Watir::Browser.new :chrome, switches: %w[
      --acceptInsecureCerts-true --start-maximized --window-size=1920,1080
    ]
    browser_version
  end

  # chrome headless browser details
  def self.chrome_headless
    @browser = Watir::Browser.new :chrome, switches: %w[
      --start-maximized --disable-gpu --headless --acceptInsecureCerts-true
      --no-sandbox --window-size=1920,1080
    ]
    browser_version
  end

  # firefox browser details
  def self.firefox
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['acceptInsecureCerts'] = true
    driver = Selenium::WebDriver.for(:firefox, desired_capabilities: caps)
    @browser = Watir::Browser.new(driver)
    browser_full_screen
    browser_version
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
    browser_version
    # browser
  end

  # ie browser details
  def self.ie
    @browser = Watir::Browser.new :ie
    browser_full_screen
    browser_version
  end

  # sarfari headless browser details
  def self.safari
    @browser = Watir::Browser.new :safari
    browser_full_screen
    browser_version
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
    browser = @browser
  end

  # Check browser version
  def self.browser_version
    browserversion = @browser.driver.capabilities[:version]
  rescue StandardError
    browserversion = 'No Browser version'
  end

  # create screenshot filename and save the screenshot if the test has failed or
  # if explictly required
  def self.check_save_screenshot(full_sc_dirname)
    if ($currentTestFail || $screenShot)
      time = Time.now.strftime('%H%M')
      if ($currentTestFail)
        scFileName = full_sc_dirname + "/Test_step-#{$testStep}_Failed_"\
                                        "#{time}.png"
      else
        # file name will be teststep.png
        scFileName = full_sc_dirname + "/Test_step-#{$testStep}_#{time}.png"
      end

      # Screenshot capture for websites
      Browser.b.screenshot.save scFileName
      Report.results.puts("Screenshot saved to: #{scFileName}")
      else
        Report.results.puts 'No screenshot requested'
      end

    # if any issues with saving the screenshot then log a warning
    rescue StandardError => error
    # construct the error message from custom text and the actual system
    # error message (converted to a string).
    $log.puts("Error saving the screenshot: #{scFileName}   #{error.to_s}")
  end
end
