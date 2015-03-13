# encoding: utf-8
require_relative 'lib/tp/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'test-unit', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.4'

  spec.authors                   = ["Jay Strybis"]
  spec.email                     = ['jay.strybis@gmail.com']

  spec.name                      = 'tp.rb'
  spec.description               = 'FANUC TP parser'
  spec.summary                   = 'Parse FANUC TP files with Ruby.'
  spec.homepage                  = 'http://github.com/onerobotics/tp.rb/'
  spec.licenses                  = ['MIT']
  spec.version                   = TP::VERSION

  spec.files                     = %w(README.md Rakefile tp.rb.gemspec)
  spec.files                    += Dir.glob("lib/**/*.rb")
  spec.files                    += Dir.glob("test/**/*")
  spec.test_files                = Dir.glob("test/**/*")

  spec.require_paths             = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
end
