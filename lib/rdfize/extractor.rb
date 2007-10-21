module RDFize
  class Extractor

    @@extractors = []
    @@file_extensions = {}
    @@mime_types = {}

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
      # TODO
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
      []
    end

  end

  module Extractors; end
end
