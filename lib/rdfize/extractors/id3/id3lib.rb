module RDFize::Extractors module ID3
  class ID3Lib < RDFize::Extractor

    # Music Ontology Specification <http://musicontology.com/>
    MO   = namespace(:mo, 'http://purl.org/ontology/mo/')
    FOAF = namespace(:foaf, 'http://xmlns.com/foaf/0.1/')

    content_type 'audio/mpeg', :extension => :mp3

    # Requires <http://rubyforge.org/projects/id3lib-ruby/>
    requires_gem :"id3lib-ruby" => '0.5.0'

    def initialize
      require 'id3lib'
    end

    def extract(resource, file, content_type)
      tag = ::ID3Lib::Tag.new(file)

      resource.rdf_type = MO.AudioFile
      resource.with_namespace(:mo) do |audio|

        #audio[:encoding] = "MP3 CBR @ 128kbps" # TODO
        audio[:encodes] = RDF::Resource.new(nil, :mo, :type => MO.DigitalSignal) do |signal|

          # TODO: mo:channels, mo:bitsPerSample, mo:sample_rate

          # <http://www.w3.org/2005/Incubator/mmsem/wiki/Music_Use_Case>
          # <http://id3lib-ruby.rubyforge.org/doc/classes/ID3Lib/Accessors.html>

          signal[:dc, :title] = tag.title if tag.title
          signal[:dc, :description] = tag.comment if tag.title
          signal[:dc, :date] = tag.year if tag.year

          ## Artist

          signal[:dc, :creator] = RDF::Resource.new(nil, :foaf, :type => MO.MusicArtist) do |artist|
            artist[:name] = tag.artist if tag.artist
          end

          ## Genre

          signal[:genre] = RDF::Resource.new(nil, :dc, :type => MO.Genre) do |genre|
            genre[:title] = tag.genre if tag.genre
          end

          # TODO: mo:Record/dc:title = tag.album
          # TODO: mo:Track/dc:title = tag.title
          # TODO: mo:trackNum = tag.track
          # TODO: tag.disc, tag.composer, tag.bpm
        end
      end
    end

  end
end end
