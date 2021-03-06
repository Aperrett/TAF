# frozen_string_literal: true

# Created on 04 Feb 2019
# @author: Andy Perrett
#
# Versions:
# 1.0 - Baseline
module Taf
  # logger.rb - logger file
  # Logger function.
  module MyLog
    def self.log
      if @logger.nil?
        @logger = Logger.new STDOUT
        @logger.level = Logger::DEBUG
        @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
      end
      @logger
    end
  end
end
