# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# junit_report.rb - methods for writing to the summary xml junit report.
module JunitReport
  require_relative '../taf_config.rb'
  # holds printable test report summary for all the executed tests
  @test_step_report_summary2 = []
  # construct the test suite header for junit
  def self.test_step_summary_xml(test_file_name, test_file_name_index,
                                 tc_start, tc_end, metrics)
    number_test_steps = [metrics.stepFailures, metrics.stepPasses,
                         metrics.stepSkipped].sum
    @test_step_report_summary2[test_file_name_index] = {
      'classname' => test_file_name,
      'name' => test_file_name,
      'assertions' => number_test_steps,
      'failures' => metrics.stepFailures,
      'tests' => metrics.stepPasses,
      'skipped' => metrics.stepSkipped,
      'time' => TimeDifference.between(
        tc_end, tc_start
      ).in_seconds
    }
  end

  def self.test_summary_junit(ts_start_time, ts_end_time, total_metrics)
    # output to XML file format for Junit for CI.
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      testsuite_attrs = {
        'classname' => CMDLine.tests_folder.to_s,
        'name' => CMDLine.tests_folder.to_s,
        'tests' => total_metrics[0].to_s,
        'failures' => total_metrics[1].to_s,
        'timestamp' => ts_start_time.to_s,
        'skipped' => total_metrics[2].to_s,
        'time' => TimeDifference.between(ts_end_time, ts_start_time)
                                .in_seconds
      }
      xml.testsuites(testsuite_attrs) do |testsuites|
        @test_step_report_summary2.each do |test_step_report_summary2|
          testsuites.testsuite(test_step_report_summary2) do |testsuite|
            $testStep_xml[test_step_report_summary2['name']]
              .each do |test_step_idx, test_step_xml|
              testsuite.testcase(test_step_xml) do |testcase|
                failure = $failtestStep_xml
                  &.[](test_step_report_summary2['name'])&.[](test_step_idx)
                skipped = $skiptestStep_xml
                  &.[](test_step_report_summary2['name'])&.[](test_step_idx)
                testcase.failure(failure) if failure
                testcase.skipped(skipped) if skipped
              end
            end
          end
        end
      end
    end

    # the test suite summary is a XML report generated will be called
    # 'report_uuid.xml'
    project_id = JsonParser.project_id.delete(' ')
    xml_dir = File.join('Results', project_id)
    ts_xml_file = "#{xml_dir}/report_#{SecureRandom.uuid}.xml"

    ts_summary_file_xml = File.open(ts_xml_file, 'w')
    ts_summary_file_xml.write builder.to_xml
    ts_summary_file_xml.close
  end
end
