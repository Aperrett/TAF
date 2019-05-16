# frozen_string_literal: true

require_relative '../taf_config.rb'
Dir[File.expand_path('handlers/**/*.rb', __dir__)].each do |f|
  require f
end
