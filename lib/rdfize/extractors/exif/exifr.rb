module RDFize::Extractors module EXIF
  class EXIFR < RDFize::Extractor

    TIFF = namespace(:tiff, 'http://ns.adobe.com/tiff/1.0/')
    EXIF = namespace(:exif, 'http://ns.adobe.com/exif/1.0/')

          MAPPINGS = {
            :ImageLength               => :image_length,
            :ImageWidth                => :image_width,
            #:BitsPerSample             => :bits_per_sample,
            :Compression               => :compression,
            :PhotometricInterpretation => :photometric_interpretation,
            #:Orientation               => :orientation,
            :SamplesPerPixel           => :samples_per_pixel,
            :PlanarConfiguration       => :planar_configuration,
          }

    content_type 'image/jpeg', :extension => [:jpeg, :jpg]
    content_type 'image/tiff', :extension => [:tiff, :tif]

    # Requires <http://rubyforge.org/projects/exifr/>
    requires_gem :exifr => '0.10.2'

    def initialize
      require 'exifr'
    end

    def extract(resource, file, content_type)
      if content_type =~ /jpeg/
        image = ::EXIFR::JPEG.new(file)

        # TODO: EXIF handling
      else
        image = ::EXIFR::TIFF.new(file)
        resource.with_namespace(:tiff) do |node|
          MAPPINGS.each do |predicate, method|
            if image.send(method)
              node[predicate] = RDF::Literal.wrap(image.send(method))
            end
          end
          node[:BitsPerSample] = RDF::Seq.new(*image.bits_per_sample)
          node[:Orientation]   = RDF::Literal.wrap(image.orientation.to_i)
        end

        # TODO: what do about TIFFs that contain multiple images?
        # TODO: EXIF handling
      end
    end

  end
end end
