#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

GEMSPEC = Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdfize'
  gem.homepage           = 'http://github.com/bendiken/rdfize' # FIXME
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'A command-line tool for converting various data formats/sources into RDF.'
  gem.description        = 'RDFize is a command-line tool for converting various data formats and data sources into RDF.'
  gem.rubyforge_project  = 'rdfize'

  gem.authors            = ['Arto Bendiken']
  gem.email              = 'arto.bendiken@gmail.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION) # TODO
  gem.bindir             = %q(bin)
  gem.executables        = %w() # TODO
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.2'
  gem.requirements               = []
  gem.add_development_dependency 'rspec', '>= 1.2.9'
  gem.add_development_dependency 'yard' , '>= 0.5.2'
  gem.add_runtime_dependency     'rdf',   '>= 0.0.4'
  gem.post_install_message       = nil
end
