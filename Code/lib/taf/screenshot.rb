# frozen_string_literal: true

# Created on 07 May 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
module Taf
  # screenshot.rb - a screenshot save function
  module Screenshot
    # create screenshot filename and save the screenshot if the test has failed.
    def self.save_screenshot(test_step_idx)
      time = Time.now.strftime('%H%M')
      sc_dir = Taf::CreateDirectories.construct_testspecdirs

      sc_file_name = "#{sc_dir}/Test_ID-#{Taf::JSONParser.test_id.delete(' ')}"\
                        "_Test_step-#{test_step_idx}_Failed_#{time}.png"

      # Screenshot capture for websites
      Taf::Browser.b.screenshot.save sc_file_name
      Taf::MyLog.log.info("Screenshot saved to: #{sc_file_name} \n")
      sc_file_name
    rescue StandardError => e
      # construct the error message from custom text and the actual system
      # error message (converted to a string).
      Taf::MyLog.log.warn("Error saving the screenshot: #{sc_file_name}   #{e}")
    end
  end
end
