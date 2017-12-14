# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# utils.rb - a repository for general functions
module Utils
  require './taf_config.rb'

  def self.currentBrowserType()
    begin
      # check if browser already created and the correct type
      if $browser.nil?
        return 'no browser'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('internet explorer') == 0)
        return 'ie'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('chrome') == 0)
        return 'chrome'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('chrome-remote') == 0)
        return 'chrome-remote'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('firefox') == 0)
        return 'firefox'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('firefox-remote') == 0)
        return 'firefox-remote'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('safari') == 0)
        return 'safari'
      elsif (($browser.driver.capabilities[:b_name]).casecmp('headless') == 0)
        return 'headless'
      else
        return 'unknown'
      end
    end
  end

  def self.open_browser
    begin
      lcBrowserType = $browserType.downcase
      selenium_grid_url = "http://localhost:4444/wd/hub"
        # set up for any normal browser type
        if((lcBrowserType == 'chrome'))
          $browser = Watir::Browser.new:chrome, :switches => %w[
            --start-maximized --window-size=1920,1080]

        elsif((lcBrowserType == 'chrome-remote'))
         $browser = Watir::Browser.new:chrome, {timeout: 120, url: 
         selenium_grid_url}

        elsif((lcBrowserType == 'firefox'))
          caps = Selenium::WebDriver::Remote::Capabilities.firefox
          caps['acceptInsecureCerts'] = true
          driver = Selenium::WebDriver.for(:firefox, desired_capabilities: caps)
          $browser = Watir::Browser.new(driver)
          # makes the browser full screen.
          screen_width = $browser.execute_script("return screen.width;")
          screen_height = $browser.execute_script("return screen.height;")
          $browser.driver.manage.window.resize_to(screen_width,screen_height)
          $browser.driver.manage.window.move_to(0,0)

        elsif((lcBrowserType == 'firefox-remote'))
          caps = Selenium::WebDriver::Remote::Capabilities.firefox
          caps['acceptInsecureCerts'] = true
          $browser = Watir::Browser.new(
            :remote,
            :url => selenium_grid_url,
            :desired_capabilities => caps)

        elsif((lcBrowserType == 'ie') || (lcBrowserType == 'safari'))
          $browser = Watir::Browser.new:"#{lcBrowserType}"
          # makes the browser full screen.
          screen_width = $browser.execute_script("return screen.width;")
          screen_height = $browser.execute_script("return screen.height;")
          $browser.driver.manage.window.resize_to(screen_width,screen_height)
          $browser.driver.manage.window.move_to(0,0)

        elsif((lcBrowserType == 'headless'))
            $browser = Watir::Browser.new:chrome, :switches => %w[
            --start-maximized --disable-gpu --headless
            --no-sandbox --window-size=1920,1080]

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
  end # open_browser

	#  Check browser version
	def self.browserVersion
	  $browserversion = $browser.driver.capabilities[:version]
	rescue
	  $browserversion = "No Browser version"
  end
  
# create screenshot filename and save the screenshot if the test has failed or if explictly required
  def self.checkSaveScreenShot(fullScDirName)
    begin
      if ($currentTestFail || $screenShot)
        time = Time.now.strftime('%m%d%H%M')
        if ($currentTestFail)
          scFileName = fullScDirName + "/FAILEDteststep-#{$testStep}-#{time}.png"
        else
          # file name will be teststepn.jpeg
          scFileName = fullScDirName + "/teststep-#{$testStep}-#{time}.png"
        end

			 # Screenshot capture for websites
       $browser.screenshot.save scFileName
			 $results_file.write("Screenshot saved to: #{scFileName}")
			 # PDF image size is 500 and add the image to a pdf.
			 size = 500
			 $PDF.image (scFileName), :fit => [size, size]
			 $PDF.text ' '
       $results_file.puts ''
       # $results_file.puts ''
        else
          $results_file.write 'No screenshot requested'
	 		    $PDF.text 'No screenshot requested'
			    $PDF.text ' '
          $results_file.puts ''
          # $results_file.puts ''
        # end
		  end

        # if any issues with saving the screenshot then log a warning
        rescue Exception => error
            # construct the error message from custom text and the actual system error message (converted to a string)
            $log.write("Error saving the screenshot: #{scFileName}   #{error.to_s}")
            $log.puts ''
        end
  end # checkSaveScreenShot

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
          # extract the test data from the test suite
          # the test spec file names are extracted differently for csv and xml files...
          # select XML or CSV depending on the file extension
          if (fileType.casecmp($XmlFileNameType) == 0)
            # process as xml...
            $XmlSuiteDoc = File.open($testSuiteFile) { |f| Nokogiri::XML(f) }
            # ...and parse...
            Utils.parseXmlTestSuiteHeaderData

          elsif (fileType.casecmp($CsvFileNameType) == 0)
            # process as csv...
            $CsvSuiteDoc = CSV.read(File.open($testSuiteFile))
            # ...and parse...
            Utils.parseCsvTestSuiteHeaderData
          else
            # the file type is not that expected so create a error message and raise an exception
            error_to_display = 'Test Suite file: \'' + $testSuiteFile.to_s + '\' type not recognised (must be .csv or .xml)'
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

  def self.parseXmlTestSuiteHeaderData
    begin

      # get the number of test specifications in the file (number of occurences of "Test_Specification"
      $numberOfTestSpecs = $XmlSuiteDoc.xpath('//Test_Specification').length

      $projectName  = $XmlSuiteDoc.at_xpath('//Project_Name').content
      $projectId    = $XmlSuiteDoc.at_xpath('//Project_ID').content
      $sprint       = $XmlSuiteDoc.at_xpath('//Sprint').content
      $testSuiteId  = $XmlSuiteDoc.at_xpath('//Test_Suite').content
      $testSuiteDes = $XmlSuiteDoc.at_xpath('//Suite_Description').content
      $tester       = $XmlSuiteDoc.at_xpath('//Tester').content

    end
  end

  def self.parseCsvTestSuiteHeaderData
    begin

      # each row in the input file is stored as an array of elements:
      # row0: header row containing test suite title fields
      # row1: Project_Name, Project_ID, Sprint
      # row2: nil
      # row3: header row containing test suite title fields
      # row4: Test_Suite, Suite_Description, Tester
      # row5: nil
      # row6: header row containing test suite title fields
      # row7: Test_ID, Test_Specification, Browser_Type
      # row8: repeat of previous row with each test specification file until <endOfFile>

      # get the number of test specifications in the file (number or rows - number of non test spec rows)
      $numberOfTestSpecs = ($CsvSuiteDoc.length) - 7

      # get the CSV file row containing the header data
      headerRow     = $CsvSuiteDoc[1]
      $projectName  = headerRow[0, 1][0]
      $projectId    = headerRow[1, 1][0]
      $sprint       = headerRow[2, 1][0]

      # get the CSV file row containing more header data
      headerRow = $CsvSuiteDoc[4]
      $testSuiteId  = headerRow[0, 1][0]
      $testSuiteDes = headerRow[1, 1][0]
      $tester       = headerRow[2, 1][0]

    end
  end

  def self.parseTestSuiteData(testSpecIndex)
    begin

      # get the file type
      fileType = File.extname($testSuiteFile)

      # select XML or CSV depending on the file extension of the test file name
        if (fileType.casecmp($XmlFileNameType) == 0)
          Utils.parseXmlTestSuiteData(testSpecIndex)

        elsif (fileType.casecmp($CsvFileNameType) == 0)
          Utils.parseCsvTestSuiteData(testSpecIndex)

        else
          # the file type is not that expected so create a error message and raise an exception
          error_to_display = 'Test Suite file: \'' + $testSuiteFile.to_s + '\' type not recognised (must be .csv or .xml)'
          raise IOError, error_to_display
        end
    end
  end

  def self.parseCsvTestSuiteData(testSpecIndex)
    begin
      # each row in the input file is stored as an array of elements:
      # row0: header row containing test suite title fields
      # row1: Project_Name, Project_ID, Sprint
      # row2: nil
      # row3: header row containing test suite title fields
      # row4: Test_Suite, Suite_Description, Tester
      # row5: nil
      # row6: header row containing test suite title fields
      # row7: Test_ID, Test_Specification, Browser_Type, Environment type
      # row8: repeat of previous row with each test specification file until <endOfFile>

      # get the CSV file row containing the desired test spec data
      headerRow = $CsvSuiteDoc[testSpecIndex + 7]
      $testId        = headerRow[0, 1][0]
      $testSpecDesc  = headerRow[1, 1][0]
      $browserType   = headerRow[2, 1][0]
      $env_type      = headerRow[3, 1][0]
    end
  end

  def self.parseXmlTestSuiteData(testSpecIndex)
    begin
      $testId       = $XmlSuiteDoc.xpath('//Test_ID')[testSpecIndex].content
      $testSpecDesc = $XmlSuiteDoc.xpath('//Test_Specification')[testSpecIndex].content
      $browserType  = $XmlSuiteDoc.xpath('//Browser')[testSpecIndex].content
      $env_type     = $XmlSuiteDoc.xpath('//environement')[testSpecIndex].content
    end
  end

  def self.readTestData(testFileName)
    begin

    # get the file type
    fileType = File.extname(testFileName)

    # select XML or CSV depending on the file extension of the test file name
      if (fileType.casecmp($XmlFileNameType) == 0)
        puts ''
        print 'Processing test file: ', testFileName
        puts ''
        puts "Browser Type: #{$browserType}"
        puts "Environment: #{$env_type}"
        $XmlDoc = File.open(testFileName) { |f| Nokogiri::XML(f) }
        Utils.parseXmlTestHeaderData
        return 'XML'

      elsif (fileType.casecmp($CsvFileNameType) == 0)
        puts ''
        print 'Processing test file: ', testFileName
        puts ''
        puts "Browser Type: #{$browserType}"
        puts "Environment: #{$env_type}"
        $CsvDoc = CSV.read(File.open(testFileName))
        Utils.parseCsvTestHeaderData
        return 'CSV'

      else
        # if unable to read the test file list then construct a custom error message and raise an exception
        error_to_display = 'Test File Name: \'' + testFileName.to_s + '\' type not recognised (must be .csv or .xml)'
        raise IOError, error_to_display
      end

        # if an error occurred reading the test file list then re-raise the exception
        rescue Exception => error
            raise IOError, error
        end
  end # readTestData

  def self.parseCsvTestHeaderData
    # each row in the input file is stored as an array of elements:
    # row0: header row containing the header title fields
    # row1: Project_Name, Project_ID, Sprint
    # row2: nil
    # row3: header row containing the test header title fields
    # row4: Test_ID, Test_Description, Browser_Type
    # row5: nil
    # row6: header row containing the test step header title fields
    # row7: Test_Step, Test_Step_Description, Test_Step_Function,
    # Test_Step_Value, S, Test_Step_Value2, Screenshot, nil
    # repeat of previous row with each test step data until <endOfFile>

    # get the number of test steps in the file (number or rows - number of non-test step rows)
    $numberOfTestSteps = ($CsvDoc.length) - 7

    # NB: the projectName, projectId and sprint data is now sourced from the test suite file

    # get the CSV file row containing the header data
    # NB: the testId and browserType data is now sourced from the test suite file
    headerRow = $CsvDoc[4]
    $testDes = headerRow[1, 1][0]

  end # parseCsvTestHeaderData

  def self.parseXmlTestHeaderData
    # get the number of test steps in the file
    $numberOfTestSteps = $XmlDoc.xpath('//Test_Step').length
    # get the remaining test data
    $testDes = $XmlDoc.at_xpath('//Test_Description').content
  end # parseXmlTestHeaderData

  def self.parseTestStepData(testFileType, testStepIndex)
    begin
      # clear the global test step data
      Utils.clearTestStepData
        if (testFileType == 'CSV')
          # each row in the input file is stored as an array of elements:
          # row0: header row containing the header title fields
          # row1: Project_Name, Project_ID, Sprint
          # row2: nil
          # row3: header row containing the test header title fields
          # row4: Test_ID, Test_Description, Browser_Type
          # row5: nil
          # row6: header row containing the test step header title fields
          # row7: Test_Step, Test_Step_Description, Test_Step_Function,
          # Test_Step_Value, Test_Step_Value2, Screenshot, nil
          # repeat of previous row with each test step data until...
          # nil, <endOfFile>

          row = $CsvDoc[testStepIndex]

          # read data
          $testStep         = row[0, 1][0]
          $testStepDes      = row[1, 1][0]
          $testStepFunction = row[2, 1][0]
          $test_value       = row[3, 1][0]
          $locate           = row[4, 1][0]
          $test_value2      = row[5, 1][0]
          $locate2          = row[6, 1][0]

          # get screenshot request, check for a null value and default to 'N'
          screenShotData    = row[7, 1][0]

            if (screenShotData.to_s.empty?)
              $screenShot = 'N'
            else
              $screenShot = screenShotData
            end

        else # testFileType == "XML"

          $testStep         = $XmlDoc.xpath('//Test_Step')[testStepIndex].content
          $testStepDes      = $XmlDoc.xpath('//Test_Step_Description')[testStepIndex].content
          $testStepFunction = $XmlDoc.xpath('//Test_Step_Function')[testStepIndex].content
          $test_value       = $XmlDoc.xpath('//Test_Step_Value')[testStepIndex].content
          $locate           = $XmlDoc.xpath('//Locator_Finder_Value')[testStepIndex].content
          $test_value2      = $XmlDoc.xpath('//Test_Step_Value2')[testStepIndex].content
          $locate2          = $XmlDoc.xpath('//Locator_Finder_Value2')[testStepIndex].content

          # get screenshot request, check for a null value and default to 'N'
          screenShotData    = $XmlDoc.xpath('//Screenshot')[testStepIndex].content

      	    if (screenShotData.to_s.empty?)
      	      $screenShot = 'N'
      	    else
      	      $screenShot = screenShotData
      	    end

        end

        # convert test step function to lower case to remove any case-variation
        $testStepFunction.downcase!

        # convert to lower case and then to a boolean value
        $screenShot.downcase!
          if ($screenShot == 'y')
             $screenShot = true
          else
            $screenShot = false
          end

        # if there is an element locator then use it, otherwise default to use an ID
        if ($locate.to_s == '')
          $locate = 'id'
        end

        if ($locate2.to_s == '')
          $locate2 = 'id'
        end

        # if an error reading the test step data then re-raise the exception
        rescue Exception
          raise
        end
  end # parseTestStepData

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
  end # clearTestStepData
end
