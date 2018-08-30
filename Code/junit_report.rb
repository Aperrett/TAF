# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# junit_report.rb - methods for writing to the summary xml junit report.
module JunitReport
  require './taf_config.rb'
  # construct the test suite header for junit
  def self.test_step_summary_xml(test_file_name, test_file_name_index)
    $testStepReportSummary2[test_file_name_index] = {
      'classname' => test_file_name,
      'name' => test_file_name,
      'assertions' => $numberOfTestSteps,
      'failures' => $testStepFailures,
      'tests' => $testStepPasses,
      'skipped' => $testStepNotrun,
      'time' => TimeDifference.between($test_case_end_time, $test_case_start_time).in_seconds
    }
  end

  def self.test_summary_junit
    # output to XML file format for Junit for CI.
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      testsuite_attrs = {
        'classname' => $testSuiteFile.to_s,
        'name' => $testSuiteFile.to_s,
        'tests' => $totalTests.to_s,
        'failures' => $totalTestFailures.to_s,
        'timestamp' => $test_start_time.to_s,
        'skipped' => $totalTestNotrun.to_s,
        'time' => TimeDifference.between($test_end_time, $test_start_time).in_seconds
      }
      xml.testsuites(testsuite_attrs) do |testsuites|
        $testStepReportSummary2.each do |testStepReportSummary2|
          testsuites.testsuite(testStepReportSummary2) do |testsuite|
            $testStep_xml[testStepReportSummary2['name']].each do |testStepIndex, testStep_xml|
              testsuite.testcase(testStep_xml) do |testcase|
                failure = $failtestStep_xml&.[](testStepReportSummary2['name'])&.[](testStepIndex)
                skipped = $skiptestStep_xml&.[](testStepReportSummary2['name'])&.[](testStepIndex)
                testcase.failure(failure) if failure
                testcase.skipped(skipped) if skipped
              end
            end
          end
        end
      end
    end

    # output XML content to console for debug
    # puts builder.to_xml

    # open the suite summary file for writing if not already open
    if !File.exist?($TestSuiteSummaryXML) || $TestSuiteSummaryXML.closed?
      $testSuiteSummaryFile_xml = File.open($TestSuiteSummaryXML, 'w+')
      $testSuiteSummaryFile_xml.write builder.to_xml
    elsif $log.puts "test suite summary file xml name: #{$TestSuiteSummaryXML} is already open"
    end

    # if the file is open then close it
    $testSuiteSummaryFile_xml.close unless $testSuiteSummaryFile_xml.closed?
  end
end