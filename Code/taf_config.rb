# frozen_string_literal: true

# Created on 20 Sept 2017
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
#
# taf_config.rb - Framework Config file

# list of all the required gems.
require 'selenium-webdriver'
require 'watir'
require 'rubygems'
require 'fileutils'
require 'logger'
require 'net/ping'
require 'nokogiri'
require 'time_difference'
require 'colored'
require 'rubyXL'

# list of all the required files
require_relative './utils/test_steps'
require_relative './report/report'
require_relative './utils/browser'
require_relative './utils/create_directories'
require_relative './utils/test_engine'
require_relative './utils/exceptions'
require_relative './report/junit_report'
require_relative './report/report_summary'
require_relative './parser/parser'
require_relative './parser/xlsx_parser'

# Require all test step handlers, which register themselves with
# TestStep.handlers when the files are required.
require_relative './functions/handlers'
