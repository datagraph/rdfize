#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdfize'
  gem.homepage           = 'http://rdfize.rubyforge.org/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'A command-line tool for converting various data formats/sources into RDF.'
  gem.description        = 'RDFize is a command-line tool for converting various data formats and data sources into RDF.'
  gem.rubyforge_project  = 'rdfize'

  gem.author             = 'Datagraph'
  gem.email              = 'rdfize@googlegroups.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w(rdfize)
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.9.2'
  gem.requirements               = []
  gem.add_runtime_dependency     'rdf-raptor',     '>= 0.3.0'
  gem.add_runtime_dependency     'rdf',            '>= 0.3.0'
  gem.add_development_dependency 'yard' ,          '>= 0.7.0'
  gem.add_development_dependency 'rspec',          '>= 2.6.0'
  gem.add_development_dependency 'rdf-spec',       '>= 0.3.0'
  gem.post_install_message       = nil
end
