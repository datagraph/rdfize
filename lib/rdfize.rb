require 'rdf'        # @see http://rubygems.org/gems/rdf
require 'rdf/raptor' # @see http://rubygems.org/gems/rdf-raptor

module RDFize
  autoload :Extractor, 'rdfize/extractor'
  autoload :VERSION,   'rdfize/version'
end

module RDFize
  class Turtle < Extractor
    content_type 'text/turtle',           :weight => 1.0
    content_type 'application/turtle',    :weight => 1.0
    content_type 'application/x-turtle',  :weight => 1.0
  end

  class N3 < Extractor
    content_type 'text/n3',               :weight => 0.9
    content_type 'text/rdf+n3',           :weight => 0.9
  end

  class NQuads < Extractor
    content_type 'text/nquads',           :weight => 0.8
    content_type 'text/x-nquads',         :weight => 0.8
  end

  class NTriples < Extractor
    content_type 'text/ntriples',         :weight => 0.8
    content_type 'text/x-ntriples',       :weight => 0.8
    content_type 'text/plain',            :weight => 0.5
  end

  class TriX < Extractor
    content_type 'application/trix',      :weight => 0.7
  end

  class RDFXML < Extractor
    content_type 'application/rdf+xml',   :weight => 0.6
  end

  class RDFJSON < Extractor
    content_type 'application/json',      :weight => 0.5
  end

  class RDFa < Extractor
    content_type 'application/xhtml+xml', :weight => 0.1
  end
end
