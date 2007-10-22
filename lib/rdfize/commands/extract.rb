#!/usr/bin/env ruby -w

require 'optparse'
require 'rubygems'
require 'rdfize'
require 'open-uri'

module RDFize module Commands
  class Extract

    def initialize(*argv)
      @inputs = argv
      @options = {}

      opts = OptionParser.new
      opts.banner = "Usage: #{File.basename($0)} [options] input ..."
      opts.on('-o', '--output=FILE', 'Specify output file; default is to write to stdout.') { |f| @options[:output] = f }
      opts.on('-t', '--type=MIME', 'Specify input MIME content type explicitly.') { |t| @options[:type] = t }
      opts.separator ''
      opts.on('--namespaces', 'Display list of known RDF namespaces, and exit.') { list_namespaces; exit }
      opts.on('--mime-types', 'Display list of supported MIME content types, and exit.') { list_mime_types; exit }
      opts.on('--extractors', 'Display list of available extractors, and exit.') { list_extractors; exit }
      opts.on('-d', '--debug', 'Enable debug output for troubleshooting.') { $DEBUG = true }
      opts.on('-v', '--verbose', 'Enable verbose output. May be given more than once.') { $VERBOSE = true }
      opts.on('-V', '--version', 'Display the RDFize version, and exit.') { abort "RDFize #{RDFize::VERSION::STRING}" }
      opts.on('-?', '--help', 'Display this help message.') { abort opts.to_s }

      begin
        opts.parse!(@inputs)
      rescue OptionParser::ParseError => e
        warn "#{File.basename($0)}: #{e.message}"
        abort opts.to_s
      end

      if @inputs.empty?
        warn 'Please specify at least one input file for extraction.'
        warn opts.to_s
      end
    end

    def run
      @inputs.each do |file|
        abort("#{File.basename($0)}: #{file}: No such file or directory.") unless File.exists?(file)
      
        mime_type = @options[:type] || RDFize::Extractor.mime_type(file)
        abort("#{File.basename($0)}: #{file}: Unable to determine content type.") unless mime_type

        extractor = RDFize::Extractor.for(mime_type)
        abort("#{File.basename($0)}: #{file}: No extractor for content type #{mime_type}.") unless extractor

        extractor.extract(file, mime_type)
      end
    end

    def list_namespaces
      RDF::Namespace.prefixes.map { |k, v| [k.to_s, v] }.sort.each do |prefix, uri|
        puts '%-32s %s' % [prefix, uri]
      end
    end

    def list_mime_types
      RDFize::Extractor.mime_types(true).each do |type, extractors|
        exts = RDFize::Extractor.file_extensions(type)
        puts '%-32s %s' % [type, exts.sort.join(' ')]
      end
    end

    def list_extractors
      RDFize::Extractor.extractors(true).each do |extractor|
        puts "#{extractor}"
        if extractor.respond_to?(:requires_gems)
          puts "\tRequires gems:\t\t#{extractor.requires_gems.keys.join(', ')}"
        end
        if extractor.respond_to?(:requires_bins)
          puts "\tRequires binaries:\t#{extractor.requires_bins.keys.join(', ')}"
        end
      end
    end

  end
end end

RDFize::Commands::Extract.new(*ARGV).run
