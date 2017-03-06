# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beautiful/log/version'

Gem::Specification.new do |spec|
  spec.name          = 'beautiful-log'
  spec.version       = Beautiful::Log::VERSION
  spec.authors       = ['nogahighland']
  spec.email         = ['noga.highland@gmail.com']

  spec.summary       = ''
  spec.description   = 'beautiful-log provides a delightful means of displaying useful and beautiful log in Ruby on Rails application.'
  spec.homepage      = 'https://github.com/nogahighland/beautiful-log/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'awesome_print', '~> 1.7.0'
end
