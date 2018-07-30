# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# utils.rb - a repository for general functions
module Utils
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

  # read in the data from the test suite file
  def self.readTestSuiteData
    begin
        # check if the file list exists and is readable
        if (File.file?($testSuiteFile) & File.readable?($testSuiteFile))
          puts ''
          print 'Processing test suite file: ', $testSuiteFile
          puts ''
          # get the file type
          fileType = File.extname($testSuiteFile)
          # extract the test data from the test suite xlsx file type

          if (fileType.casecmp($XlsxFileNameType) == 0)
            # process as xlsx...
            $XlsxSuiteDoc = RubyXL::Parser.parse($testSuiteFile)
            # ...and parse...
            Utils.parseXlxsTestSuiteHeaderData
          else
            # the file type is not that expected so create a error message and raise an exception
            error_to_display = 'Test Suite file: \'' + $testSuiteFile.to_s + '\' type not recognised (must be .xlsx)'
            raise IOError, error_to_display
          end
          # if unable to read the test file list then construct a custom error message and raise an exception
        elsif error_to_display = 'Test Suite file: \'' + $testSuiteFile.to_s + '\' does not exist or is unreadable'
            raise IOError, error_to_display
        end
      # if an error occurred reading the test file list then re-raise the exception
      rescue Exception => error
          raise error
      end
  end

  def self.parseXlxsTestSuiteHeaderData
    begin
      # get the number of test specifications in the file (number of
      # occurences of "Test_Specification"
      $numberOfTestSpecs = $XlsxSuiteDoc[0].sheet_data.size - 7

      worksheet = $XlsxSuiteDoc[0]
      $projectName = worksheet.sheet_data[1][0].value
      $projectId = worksheet.sheet_data[1][1].value
      $sprint = worksheet.sheet_data[1][2].value

      $testSuiteId = worksheet.sheet_data[4][0].value
      $testSuiteDes = worksheet.sheet_data[4][1].value
      $tester  = worksheet.sheet_data[4][2].value
    end
 end

  def self.parseTestSuiteData(testSpecIndex)
    # get the file type
    fileType = File.extname($testSuiteFile)

    # select Xlsx depending on the file extension of the test file name
    if (fileType.casecmp($XlsxFileNameType) == 0)
      Utils.parseXlxsTestSuiteData(testSpecIndex)
    else
      # the file type is not that expected so create a error message and raise an exception
      errorToDisplay = 'Test Suite file: \'' + $testSuiteFile.to_s + '\' type not recognised (must be .xlsx)'
      raise IOError, errorToDisplay
    end
  end

  def self.parseXlxsTestSuiteData(testSpecIndex)
    worksheet = $XlsxSuiteDoc[0]

    worksheet[7..$numberOfTestSpecs+7].map do |row|
      suite = {
        id: row[0].value,
        specdesc: row[1].value,
        env: row[3].value,
      }

      if ARGV.length < 2
        suite[:browser] = row[2].value
      elsif ARGV.length < 3
        suite[:browser] = ARGV[1]
      else
        raise IOError, 'Unable to open browser'  
      end

      suite
    end
  end

  # readTestData
  def self.readTestData(testFileName)
    begin
    # get the file type
    fileType = File.extname(testFileName)

    # select xlsx depending on the file extension of the test file name
    if (fileType.casecmp($XlsxFileNameType) == 0)
      puts''
      print 'Processing test file: ', testFileName
      puts''
      puts"Browser Type: #{$browserType}"

      $xlsxDoc = RubyXL::Parser.parse(testFileName)
      Utils.parseXlxsTestHeaderData
      return 'XLSX'
    else
      # if unable to read the test file list then construct a custom error
      # message and raise an exception.
      error_to_display = 'Test File Name: \'' + testFileName.to_s + '\' type not recognised (must be .xlsx)'
      raise IOError, error_to_display
    end

      # if an error occurred reading the test file list then
      # re-raise the exception.
      rescue Exception => error
          raise IOError, error
      end
  end

  def self.parseXlxsTestHeaderData
    # get the number of test steps in the file
    $numberOfTestSteps = ($xlsxDoc[0].sheet_data.size) - 7
    worksheet = $xlsxDoc[0]
    # get the remaining test data
    $testDes      = worksheet.sheet_data[4][1].value
    puts "Number of test steps: #{$numberOfTestSteps}"
    puts "Test Description: #{$testDes}"
    
  end # parseXlxsTestHeaderData

  # parseTestStepData
  def self.parseTestStepData(testFileType, testStepIndex)
    # clear the global test step data
    Utils.clearTestStepData

    worksheet = $xlsxDoc[0]
    worksheet[7..$numberOfTestSteps+7].map do |row|
      test = {
        testStep: row[0].value,
        testdesc: row[1].value,
        testFunction: row[2].value,
        testvalue: row[3].value,
        locate: row[4].value,
        testvalue2: row[5].value,
        locate2: row[6].value,
        screenShotData: row[7].value,
        skipTestCase: row[8].value,
      }

      # convert test step, screenshot and skip test case functions to lowercase.
      test[:testFunction].downcase!

      # get screenshot request, check for a null value and default to 'N'

      if (test[:screenShotData] == 'Y')
        test[:screenShotData] = true
      elsif (test[:screenShotData] == 'N')
        test[:screenShotData] = false
      else
        test[:screenShotData] = false
      end

      if (test[:skipTestCase] == 'Y')
        test[:skipTestCase] = true
      elsif(test[:skipTestCase] == 'N')
        test[:skipTestCase] = false
      else
        test[:skipTestCase] = false
      end

      # if there is an element locator then use it, otherwise use an ID
      if (test[:locate].to_s == '')
        test[:locate] = 'id'
      end

      if (test[:locate2].to_s == '')
        test[:locate2] = 'id'
      end

      test
    end
  end

  # clearTestStepData
  def self.clearTestStepData
    # clear the global test step data so the value from the previous test,
    # doesn't persist if the read data fails for the current test step
    $testStep         = 0
    $testStepDes      = ''
    $testStepFunction = ''
    $test_value       = ''
    $locate           = ''
    $test_value2      = ''
    $locate2          = ''
    $screenShot       = ''
    $skipTestCase     = ''
  end
end
