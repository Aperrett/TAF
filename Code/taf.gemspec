# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'taf/version'

Gem::Specification.new do |taf|
  taf.name        = 'taf'
  taf.version     = Taf::VERSION
  taf.summary     = 'TAF to allow simple web automation.'
  taf.description = 'Test Automation Framework (TAF) to allow simple test' \
                      ' web automation - releaseflag use'
  taf.authors     = ['Andy Perrett']
  taf.require_paths = ['lib']
  taf.files       = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  taf.executables = ['taf']
  taf.homepage    = 'https://github.com/Aperrett/TAF'
  taf.license     = 'MIT'
  taf.post_install_message = 'Thanks for installing TAF! - releaseflag use'
  taf.required_ruby_version = '>= 2.5.1'
  taf.add_development_dependency 'bundler', '~> 2.02'
  taf.add_development_dependency 'rspec', '~> 3.8'
  taf.add_runtime_dependency 'bundler-audit', '~> 0.6'
  taf.add_runtime_dependency 'colored', '~> 1.2'
  taf.add_runtime_dependency 'faraday', '~> 0.15'
  taf.add_runtime_dependency 'json', '~> 2.2'
  taf.add_runtime_dependency 'logger', '~> 1.2'
  taf.add_runtime_dependency 'rubygems-update', '~> 2.7'
  taf.add_runtime_dependency 'selenium-webdriver', '~> 3.14'
  taf.add_runtime_dependency 'time_difference', '~> 0.7'
  taf.add_runtime_dependency 'watir', '~> 6.16'
end
