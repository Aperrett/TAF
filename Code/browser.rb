# Created on 02 Aug 2018
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# Browser.rb - a browser functions
module Browser
  require './taf_config.rb'

  def self.currentBrowserType
      # begin
      # check if browser already created and the correct type
      if $browser.nil?
        'no browser'
      elsif $browser.driver.capabilities[:b_name].casecmp('internet explorer').zero?
        'ie'
      elsif $browser.driver.capabilities[:b_name].casecmp('chrome').zero?
        'chrome'
      elsif $browser.driver.capabilities[:b_name].casecmp('chrome-headless').zero?
        'chrome-headless'
      elsif $browser.driver.capabilities[:b_name].casecmp('firefox').zero?
        'firefox'
      elsif $browser.driver.capabilities[:b_name].casecmp('firefox-headless').zero?
        'firefox-headless'
      elsif $browser.driver.capabilities[:b_name].casecmp('safari').zero?
        'safari'
      else
        'unknown'
      end
  end

# open_browser function
def self.open_browser
  lcBrowserType = $browserType.downcase
  # set up for any normal browser type
  if lcBrowserType == 'chrome'
    $browser = Watir::Browser.new :chrome, switches: %w[
      --start-maximized --window-size=1920,1080
    ]

  elsif lcBrowserType == 'chrome-headless'
    $browser = Watir::Browser.new :chrome, switches: %w[
      --start-maximized --disable-gpu --headless --acceptInsecureCerts-true
      --no-sandbox --window-size=1920,1080
    ]

  elsif lcBrowserType == 'firefox'
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['acceptInsecureCerts'] = true
    driver = Selenium::WebDriver.for(:firefox, desired_capabilities: caps)
    $browser = Watir::Browser.new(driver)
    # makes the browser full screen.
    screen_width = $browser.execute_script('return screen.width;')
    screen_height = $browser.execute_script('return screen.height;')
    $browser.driver.manage.window.resize_to(screen_width, screen_height)
    $browser.driver.manage.window.move_to(0, 0)

  elsif lcBrowserType == 'firefox-headless'
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
    caps['acceptInsecureCerts'] = true
    driver = Selenium::WebDriver.for(:firefox, options: options, desired_capabilities: caps)
    $browser = Watir::Browser.new(driver)
    # makes the browser full screen.
    # screen_width = $browser.execute_script("return screen.width;")
    # screen_height = $browser.execute_script("return screen.height;")
    $browser.driver.manage.window.resize_to(1920, 1200)
    $browser.driver.manage.window.move_to(0, 0)

  elsif (lcBrowserType == 'ie') || (lcBrowserType == 'safari')
    $browser = Watir::Browser.new :"#{lcBrowserType}"
    # makes the browser full screen.
    screen_width = $browser.execute_script('return screen.width;')
    screen_height = $browser.execute_script('return screen.height;')
    $browser.driver.manage.window.resize_to(screen_width, screen_height)
    $browser.driver.manage.window.move_to(0, 0)

    # unable to select the specified browser so throw an exception
  else
    puts "unable to open selected browser: #{$browserType}"
    raise Exception
  end

# if unable to open browser then set error message and re-raise the exception
rescue Exception => error
  # construct the error message from custom text and the actual system error message (converted to a string)
  error_to_display = "Unable to open the requested browser: #{$browserType} " + error.to_s
  raise error_to_display
end

  # Check browser version
  def self.browserVersion
    $browserversion = $browser.driver.capabilities[:version]
  rescue StandardError
    $browserversion = 'No Browser version'
  end

  # create screenshot filename and save the screenshot if the test has failed or
  # if explictly required
  def self.checkSaveScreenShot(fullScDirName)
    begin
      if ($currentTestFail || $screenShot)
        time = Time.now.strftime('%H%M')
        if ($currentTestFail)
          scFileName = fullScDirName + "/Test_step-#{$testStep}_Failed_#{time}.png"
        else
          # file name will be teststep.png
          scFileName = fullScDirName + "/Test_step-#{$testStep}_#{time}.png"
        end

       # Screenshot capture for websites
       $browser.screenshot.save scFileName
       $results_file.write("Screenshot saved to: #{scFileName} \n")
      else
        $results_file.write 'No screenshot requested', "\n"
      end

        # if any issues with saving the screenshot then log a warning
        rescue Exception => error
            # construct the error message from custom text and the actual system
            # error message (converted to a string).
            $log.write("Error saving the screenshot: #{scFileName}   #{error.to_s}")
            $log.puts ''
        end
  end 
end
