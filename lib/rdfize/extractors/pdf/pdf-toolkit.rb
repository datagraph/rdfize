module RDFize::Extractors module PDF
  class PDFToolkit < RDFize::Extractor

    INFO = ['Title', 'Author', 'Subject', 'Keywords', 'Creator', 'Producer', 'CreationDate', 'ModDate']
    PDF = namespace(:pdf, 'http://ns.adobe.com/pdf/1.3/')

    content_type 'application/pdf', :extension => :pdf

    # Requires <http://rubyforge.org/projects/pdf-toolkit/>
    requires_gem :pdf_toolkit => true

    def initialize
      require 'pdf/toolkit'
    end

    def extract(resource, file, content_type)
      pdf_file = ::PDF::Toolkit.open(file)

      resource.with_namespace(:pdf) do |pdf|
        pdf[:PDFVersion] = pdf_file.version.to_s

        INFO.each do |field|
          pdf[field] = RDF::Literal.wrap(pdf_file[field]) if pdf_file[field]
        end
      end
    end

  end
end end
