module RDF
  class Namespace

    @@prefixes ||= {
      :rdf     => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      :rdfs    => 'http://www.w3.org/2000/01/rdf-schema#',
      :xsd     => 'http://www.w3.org/2001/XMLSchema#',
      :xsi     => 'http://www.w3.org/2001/XMLSchema-instance#',
      :owl     => 'http://www.w3.org/2002/07/owl#',
      :dc      => 'http://purl.org/dc/elements/1.1/',
      :dcterms => 'http://purl.org/dc/terms/',
    }

    attr_reader :uri

    def self.prefixes
      @@prefixes
    end

    def self.prefix_for(uri)
      @@prefixes.index(uri)
    end

    def self.register!(prefix, uri)
      @@prefixes[prefix.to_sym] = uri.to_s
    end

    def self.unregister!(prefix)
      @@prefixes.delete(prefix.to_sym)
    end

    def self.[](prefix)
      raise ArgumentError.new("prefix must be a symbol, but #{prefix.inspect} given") unless prefix.is_a?(Symbol)
      raise ArgumentError.new("prefix #{prefix.inspect} not registered") unless @@prefixes.has_key?(prefix)
      self.new(@@prefixes[prefix.to_sym])
    end

    def initialize(uri)
      @uri = uri
    end

    def [](suffix)
      Resource.new("#{uri}#{suffix}", :rdfs)
    end

    def method_missing(method, *args, &block)
      self[method.to_s.gsub('_', '-')]
    end

    def prefix
      self.class.prefix_for(uri)
    end

    def to_s
      "{#{uri}}"
    end

    def inspect
      "#<#{self.class} #{uri}>"
    end

  end

  module Namespaces
    RDF  = Namespace[:rdf]
    RDFS = Namespace[:rdfs]
    XSD  = Namespace[:xsd]
    OWL  = Namespace[:owl]
    DC   = Namespace[:dc]
  end
end
