# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errata_slip/version'

Gem::Specification.new do |spec|
  spec.name          = "errata_slip"
  spec.version       = ErrataSlip::VERSION
  spec.authors       = ["Artem Fedorov"]
  spec.email         = ["artemf@mail.ru"]
  spec.summary       = %q{Apply corrections from yaml file to array of records}
  spec.description   = %q{Apply corrections from yaml file to array of records. Useful in scraping when one needs to apply errata to scraped data.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
