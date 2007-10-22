module RDFize
  class Extractor

    @@extractors = []
    @@file_extensions = {}
    @@mime_types = {}

    def self.extractors(only_available = false)
      !only_available ? @@extractors :
        @@extractors.find_all { |extractor| extractor.available? }
    end

    def self.mime_types(only_available = false)
      unless only_available
        @@mime_types
      else
        @@mime_types.reject do |type, extractors|
          extractors.find_all { |extractor| extractor.available? }.empty?
        end
      end
    end

    def self.file_extensions(mime_type)
      @@file_extensions.reject { |k, v| v != mime_type }.keys.map { |k| k.to_s }
    end

    def self.available?
      true # TODO
    end

    def self.file_extension(filename)
      filename =~ /\.([\w\d]+)$/ ? $1 : nil
    end

    def self.mime_type(filename)
      if ext = file_extension(filename)
        @@file_extensions[ext.to_sym] ||
          `file -bi #{filename}`.strip
      end
    end

    def self.for(mime_type)
      if types = @@mime_types[mime_type]
        types.first
      end
    end

    def self.inherited(child) #:nodoc:
      @@extractors << child
      super
    end

    def self.namespace(prefix, uri)
      RDF::Namespace.register! prefix, uri
      RDF::Namespace[prefix]
    end

    def self.content_type(type, options = {})
      @@mime_types[type] ||= []
      @@mime_types[type] << self

      if options[:extension]
        extensions = [options[:extension]].flatten.map { |ext| ext.to_sym }
        extensions.each { |ext| @@file_extensions[ext] = type }
      end
    end

    def self.requires_platform(args = {})
      # TODO
    end

    def self.requires_gem(args = {})
      klass = class << self; self; end
      klass.send :define_method, :requires_gems, lambda { args }
    end

    def self.requires_bin(args = {})
      # TODO
    end

    def self.identify(file)
      {'application/octet-stream' => 0.0}
    end

    def self.verify(file)
      true
    end

    def self.extract(file, content_type)
      extractor = self.new
      extractor.extract(file, content_type)
      extractor.resources.each { |r| r.dump }
    end

    attr_reader :resources

    def extract(file, content_type)
      []
    end

    def <<(resource)
      @resources ||= []
      @resources << resource
    end

  end

  module Extractors; end
end
