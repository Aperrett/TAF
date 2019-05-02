# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require './lib/version.rb'

Gem::Specification.new do |taf|
  taf.name        = 'taf'
  taf.version     = Taf::Version::STRING
  taf.summary     = 'TAF to allow simple web automation.'
  taf.description = 'Test Automation Framework (TAF) to allow simple test web automation - releaseflag use'
  taf.authors     = ['Andy Perrett']
  taf.require_paths = ['lib']
  taf.files       = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  taf.executables = ['taf']
  taf.homepage    = 'https://github.com/Aperrett/TAF'
  taf.license     = 'MIT'
  taf.post_install_message = 'Thanks for installing TAF! - releaseflag use'
  taf.required_ruby_version = '>= 2.5.1'
  taf.add_development_dependency 'bundler', '~> 1.16'
  taf.add_runtime_dependency 'bundler-audit', '~> 0.6'
  taf.add_runtime_dependency 'colored', '~> 1.2'
  taf.add_runtime_dependency 'json', '~> 2.2'
  taf.add_runtime_dependency 'logger', '~> 1.2'
  taf.add_runtime_dependency 'net-ping', '~> 2.0'
  taf.add_runtime_dependency 'nokogiri', '~> 1.8'
  taf.add_runtime_dependency 'rubygems-update', '~> 2.7'
  taf.add_runtime_dependency 'selenium-webdriver', '~> 3.14'
  taf.add_runtime_dependency 'time_difference', '~> 0.7'
  taf.add_runtime_dependency 'watir', '~> 6.16'
end
