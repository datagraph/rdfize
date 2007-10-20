module RDFize::Extractors
  class PDF < RDFize::Extractor

    content_type 'application/pdf', :extension => :pdf

    def self.extract(file)
      # TODO
    end

  end
end
