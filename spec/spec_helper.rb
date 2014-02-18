# encoding: UTF-8

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'

require 'errata_slip'

