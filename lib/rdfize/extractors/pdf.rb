module RDFize::Extractors
  class PDF < RDFize::Extractor

    content_type 'application/pdf', :extension => :pdf

    def self.extract(file)
      require 'pdf/toolkit'
      pdf = ::PDF::Toolkit.open(file)

      # TODO
      #puts pdf.page_count
      #puts pdf.version.to_s
      #puts pdf.to_hash.inspect
    end

  end
end
