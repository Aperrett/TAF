# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require './lib/version.rb'

Gem::Specification.new do |taf|
  taf.name        = 'taf'
  taf.version     = Taf::Version::STRING
  taf.date        = '2018-11-05'
  taf.summary     = 'Test Automation Framework to allow simple web automation.'
  taf.description = "Test Automation Framework (TAF) for more details go to: \
                      https://github.com/Aperrett/TAF"
  taf.authors     = ['Andy Perrett']
  taf.require_paths = ['lib']
  taf.files       = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  taf.executables = ['taf']
  taf.homepage    = 'https://github.com/Aperrett/TAF'
  taf.license     = 'MIT'
  taf.post_install_message = "Thanks for installing TAF!"
  taf.required_ruby_version = '>= 2.5.1'
  taf.add_development_dependency 'bundler', '~> 1.16', '>= 1.16.6'
  taf.add_development_dependency 'bundler-audit', '~> 0.6', '>= 0.6.0'
  taf.add_development_dependency 'colored', '~> 1.2'
  taf.add_development_dependency 'logger', '~> 1.2', '>= 1.2.8'
  taf.add_development_dependency 'net-ping', '~> 2.0', '>= 2.0.5'
  taf.add_development_dependency 'nokogiri', '~> 1.8', '>= 1.8.5'
  taf.add_development_dependency 'rubygems-update', '~> 2.7', '>= 2.7.7'
  taf.add_development_dependency 'rubyXL', '~> 3.3', '>= 3.3.30'
  taf.add_development_dependency 'selenium-webdriver', '~> 3.14', '>= 3.14.1'
  taf.add_development_dependency 'time_difference', '~> 0.7', '>= 0.7.0'
  taf.add_development_dependency 'watir', '~> 6.14', '>= 6.14.0'
end
