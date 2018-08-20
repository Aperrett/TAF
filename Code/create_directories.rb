# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# create_directories.rb - Creates folder structures.
module CreateDirectories
  # create the project directories and open the test results file,
  # returns the screenshot directory name, the screenshot will be placed in a
  # unique filename based upon the testStep.
  # A single top-level directory named after the Project ID will be used and the
  # target sub-directories will be created for each run of the test
  #
  # ----> Project directory (working directory)
  #
  # ------->directory named after the test run number
  #
  # ---------->directory named after test_id (with browser type identified)
  #
  # ------------->directory named 'Test_Results'
  #
  # ------------->directory named 'Screenshots'

  def self.construct_projectdirs
    # create top-level 'Results' directory if it doesn't already exist
    result_home = 'Results'
    Dir.mkdir(result_home) unless File.directory? result_home

    # create the 'Project' directory if it doesn't already exist
    project_id = $projectId.delete(' ')
    project_iddir = result_home + '/' + project_id
    Dir.mkdir(project_iddir) unless File.directory? project_iddir

    # Creates a folder Ran_on_Time with the time as of now.
    time = Time.new
    f_date = time.strftime('%d-%b-%Y')
    f_time = time.strftime('%H_%M_%S')
    $runNoDir = project_iddir + '/' + 'Ran_on_' + f_date + '_' + f_time
    Dir.mkdir($runNoDir)
  end

  def self.construct_testspecdirs
    # create directories for each test spec
    # create a sub-directory named from the 'testId' (with any spaces taken out)
    # if it doesn't already exist plus the browser type
    testid_dir = $runNoDir + '/' + $testId.delete(' ') + '_' + $browserType#.capitalize
    Dir.mkdir(testid_dir) unless File.directory? testid_dir

    # create a screenshot directory under the 'testId' directory - it will always need creating
    screenshot_dir = testid_dir + '/' + 'Screenshots' + '/'
    Dir.mkdir(screenshot_dir)

    # create a test results directory under the 'test run' directory - it will always need creating
    test_res_dir = testid_dir + '/' + 'Test_Results' + '/'
    Dir.mkdir(test_res_dir)

    # create absolute paths to the screenshots, test results and test suite summary directories
    abs_path_screenshot_dir = File.absolute_path(screenshot_dir)
    abs_path_test_res_dir    = File.absolute_path(test_res_dir)
    abs_path_run_no_dir      = File.absolute_path($runNoDir)

    # the test results file name will be 'testId'_Res.txt
    $testResultFileName = abs_path_test_res_dir + '/' + $testId + '_Res.txt'

    # the test suite summary file name will be 'suite_summary.txt'
    $testSuiteSummaryFileName = abs_path_run_no_dir + '/suite_summary.txt'

    # the test suite summary is a XML report generated will be called 'suite_summary.xml'
    time = Time.new
    f_date = time.strftime('%d-%b-%Y')
    f_time = time.strftime('%H_%M_%S')

    $TestSuiteSummaryXML = 'Results/' + $projectId + '/' + f_date + '_' + f_time + '_test_result.xml'

    # the log file name will be under the test ID directory
    $logFileName = testid_dir + '/TestLogFile.txt'

    print 'TestId: ', $testId
    puts ''
    print 'Screenshot directory: ', abs_path_screenshot_dir
    puts ''
    print 'Test result directory: ', abs_path_test_res_dir
    puts ''

  # if any issues then set error message and re-raise the exception
  rescue Exception => error
    # construct the error message from custom text and the actual system error message (converted to a string)
    error_to_display = 'Error creating the test directory structure or opening the test results file : ' + error.to_s
    raise error_to_display
  else
    # if no exception then return the screenshot file directory path
    abs_path_screenshot_dir
  end
end
