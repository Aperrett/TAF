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
  # the screenshot will be placed in a unique filename based upon the testStep.
  # A single top-level directory named after the Project ID will be used and the
  # target sub-directories will be created for each run of the test
  #
  # ----> Project directory (working directory)
  #
  # ------->directory named after the test run ID UUID

  def self.construct_projectdirs
    # create top-level directory if it doesn't already exist:
    # Results/Project_id
    project_id = JsonParser.project_id.delete(' ')
    project_dir = File.join('Results', project_id)

    FileUtils.mkdir_p(project_dir)

    # Generate UUID
    @run_uuid = SecureRandom.uuid
  end

  def self.construct_testspecdirs
    # create directories for each test spec for screenshots:
    # Results/Project_id/Run_ID_UUID
    project_id = JsonParser.project_id.delete(' ')
    screenshot_dir = File.join('Results', project_id, "Run_ID_#{@run_uuid}")

    abs_path_screenshot_dir = File.absolute_path(screenshot_dir)
    FileUtils.mkdir_p(abs_path_screenshot_dir)
    # if any issues then set error message and re-raise the exception
  rescue StandardError => e
    # construct the error message from custom text and the actual system error
    # message (converted to a string)
    error_to_display = 'Error creating directory:' + e.to_s
    raise error_to_display
  else
    # if no exception then return the screenshot file directory path
    abs_path_screenshot_dir
  end
end
