module RDFize::Extractors
  class PDF < RDFize::Extractor

    requires_gem :pdf_toolkit => true
    content_type 'application/pdf', :extension => :pdf

    def self.extract(file, content_type)
      require 'pdf/toolkit'
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

      resource.dump
    end

  end
end
