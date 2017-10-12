# Created on 20 Sept 2017
# @author: Andy Perrett
# MIT License
# Copyright (c) 2017 Aperrett
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
    # create top-level 'Project' directory if it doesn't already exist
    project_iddir = $projectId.gsub(' ', '')
      if (!File.directory? (project_iddir))
        Dir.mkdir(project_iddir)
      end

    # create a directory from the 'test run' number - find the highest
    # existing number already used and start at the next highest number
    directories = Dir.entries(project_iddir).sort
    final_dir = directories.last

      # get the value of the next number in the sequence, if no directories exist then start at 1
      if (final_dir.include? ('Run_'))
        start_numindex = final_dir.index('Run_') + 4 # the number index starts at 4 chars from the 'Run_'
        num_char = final_dir[start_numindex, 2]
        run_number = num_char.to_i + 1
      else
        run_number = 1
      end

      # print a leading zero if a single digit
      if run_number.between?(0, 9)
        $runNoDir = project_iddir + '/' + 'Run_0' + run_number.to_s
      else
        $runNoDir = project_iddir + '/' + 'Run_' + run_number.to_s
      end

      Dir.mkdir($runNoDir)
  end

  def self.construct_testspecdirs
    begin

    # create directories for each test spec
    # create a sub-directory named from the 'testId' (with any spaces taken out)
    # if it doesn't already exist plus the browser type
        testid_dir = $runNoDir + '/' + $testId.gsub(' ', '') + '_' + $browserType.capitalize
      if (!File.directory? (testid_dir)) then
        Dir.mkdir(testid_dir)
      end

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

    # the test results file name will be 'testId'_Res.pdf
    $testResultFileNamePDF = abs_path_test_res_dir + '/' + $testId + '_Res.pdf'

    # the test suite summary file name will be 'suite_summary.txt'
    $testSuiteSummaryFileName = abs_path_run_no_dir + '/suite_summary.txt'

    # the test suite summary is a pdf report generated will be called 'suite_summary.pdf'
    $TestSuiteSummaryPDF = abs_path_run_no_dir + '/suite_summary.pdf'

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
    raise RuntimeError, error_to_display
  else
    # if no exception then return the screenshot file directory path
    return abs_path_screenshot_dir
      end
  end
end
