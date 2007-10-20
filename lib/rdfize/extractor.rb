module RDFize
  class Extractor

    @@extractors = []
    @@file_extensions = {}
    @@mime_types = {}

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

    def self.identify(file)
      {'application/octet-stream' => 0.0}
    end

    def self.verify(file)
      true
    end

    def self.extract(file)
      []
    end

  end

  module Extractors; end
end
