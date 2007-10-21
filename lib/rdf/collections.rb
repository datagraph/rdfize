module RDF
  module Collections
    BAG = Namespaces::RDF.bag
    SEQ = Namespaces::RDF.seq
    ALT = Namespaces::RDF.alt
  end

  class Collection < Resource
    def initialize(*values, &block)
      super uri, :rdf, :type => RDF::Collections::SEQ
      values.each { |value| self << value }
    end

    def <<(value)
      self[:li] ||= []
      self[:li] << value
    end
  end

  class Bag < Collection; end

  class Seq < Collection; end

  class Alt < Collection; end
end
