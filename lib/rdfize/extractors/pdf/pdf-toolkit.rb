module RDFize::Extractors module PDF
  class PDFToolkit < RDFize::Extractor

    content_type 'application/pdf', :extension => :pdf

    # Requires <http://rubyforge.org/projects/pdf-toolkit/>
    requires_gem :pdf_toolkit => true

    def initialize
      require 'pdf/toolkit'
    end

    def extract(file, content_type)
      pdf = ::PDF::Toolkit.open(file)

      # TODO
      puts pdf.page_count
      puts pdf.version.to_s
      puts pdf.to_hash.inspect

      info = pdf.to_hash
      #mappings = { 'Producer', 'Creator', 'Author', 'CreationDate', 'ModDate', 'Title', 'Keywords' }
      resource = RDF::Resource.new(nil, :dc) do |r|
        r[:creator_]  = info['Producer']
        r[:created_]  = info['CreationDate']
        r[:modified_] = info['ModDate']
      end

      self << resource
    end

  end
end end
