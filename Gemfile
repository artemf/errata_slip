source 'https://rubygems.org'

# Specify your gem's dependencies in errata_slip.gemspec
gemspec

group :test do
  if ENV["CI"]
    gem "coveralls", require: false
  end
end