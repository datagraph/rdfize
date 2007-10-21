#!/usr/bin/env ruby -w

require 'optparse'
require 'rubygems'
require 'rdfize'
require 'open-uri'

OPTIONS = {}
args = ARGV.options do |opt|
  opt.banner = "Usage: #{File.basename($0)} [options] input ..."
  opt.on('-o', '--output=FILE', 'Specify output file; default is to write to stdout.') { |f| OPTIONS[:output] = f }
  opt.on('-t', '--type=MIME', 'Specify input MIME content type explicitly.') { |t| OPTIONS[:type] = t }
  opt.separator ''
  opt.on('-d', '--debug', 'Enable debug output for troubleshooting.') { $DEBUG = true }
  opt.on('-v', '--verbose', 'Enable verbose output. May be given more than once.') { $VERBOSE = true }
  opt.on('-V', '--version', 'Display the RDFize version, and exit.') { abort "RDFize #{RDFize::VERSION::STRING}" }
  opt.on('-?', '--help', 'Display this help message.') { warn opt; exit }
end

begin
  args.parse!
rescue OptionParser::ParseError => e
  warn "#{File.basename($0)}: #{e.message}"
  abort args.to_s
end

if ARGV.empty?
  warn 'Please specify at least one input file for extraction.'
  warn args.to_s
else
  ARGV.each do |file|
    abort("#{File.basename($0)}: #{file}: No such file or directory.") unless File.exists?(file)

    mime_type = OPTIONS[:type] || RDFize::Extractor.mime_type(file)
    abort("#{File.basename($0)}: #{file}: Unable to determine content type.") unless mime_type

    extractor = RDFize::Extractor.for(mime_type)
    abort("#{File.basename($0)}: #{file}: No extractor for content type #{mime_type}.") unless extractor

    extractor.extract(file, mime_type)
  end
end
