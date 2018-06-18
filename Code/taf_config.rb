# Created on 20 Sept 2017
# @author: Andy Perrett
# MIT License
# Copyright (c) 2017 Aperrett
# Versions:
# 1.0 - Baseline
#
# taf_config.rb - Framework Config file
module TafConfig
  # list of all the required gems.
  require 'selenium-webdriver'
  require 'watir'
  require 'rubygems'
  require 'fileutils'
  require 'logger'
  require 'net/ping'
  require 'nokogiri'
  require 'csv'
  require 'time_difference'
  require 'colored'

  # list of all the required files
  require_relative 'test_steps.rb'
  require_relative 'report.rb'
  require_relative 'utils.rb'
  require_relative 'create_directories.rb'
  require_relative 'test_engine.rb'
  require_relative 'report.rb'
  require_relative 'web_functions.rb'
end # end of module.
