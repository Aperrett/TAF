# frozen_string_literal: true

# Created on 07 May 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# screenshot.rb - a screenshot save function
module Screenshot
  require_relative '../taf_config.rb'

  # create screenshot filename and save the screenshot if the test has failed or
  # if explictly required
  def self.save_screenshot(screen_shot, test_step_idx)
    if $currentTestFail || screen_shot
      time = Time.now.strftime('%H%M')
      sc_dir = CreateDirectories.construct_testspecdirs

      sc_file_name = if $currentTestFail
                       "#{sc_dir}/Test_ID-#{$testId.delete(' ')}"\
                        "_Test_step-#{test_step_idx}_Failed"\
                        "_#{time}.png"
                     else
                       "#{sc_dir}/Test_ID-#{$testId.delete(' ')}"\
                        "_Test_step-#{test_step_idx}_#{time}.png"
                     end

      # Screenshot capture for websites
      Browser.b.screenshot.save sc_file_name
      MyLog.log.info("Screenshot saved to: #{sc_file_name} \n")
    else
      MyLog.log.debug "No screenshot requested \n"
    end

    # if any issues with saving the screenshot then log a warning
  rescue StandardError => e
    # construct the error message from custom text and the actual system
    # error message (converted to a string).
    MyLog.log.warn("Error saving the screenshot: #{sc_file_name}   #{e}")
  end
end
