module RDFize::Extractors
  ##
  # Requires <http://rubyforge.org/projects/vpim/>
  # Ontology defined in <http://www.w3.org/TR/vcard-rdf>
  class VCard < RDFize::Extractor

    RDF::Namespace.register! :vcard, 'http://www.w3.org/2001/vcard-rdf/3.0#'
    VCARD = RDF::Namespace[:vcard]

    BASICS = [:FN, :NICKNAME, :BDAY, :MAILER, :GEO, :TITLE, :ROLE, :CATEGORIES,
              :NAME, :SOURCE, :NOTE, :PRODID, :REV, :"SORT-STRING", :CLASS]

    requires_gem :vpim => true
    content_type 'text/x-vcard', :extension => :vcard
    content_type 'text/directory', :extension => :vcf

    def self.extract(file)
      require 'vpim/vcard'

      resources = []
      cards = Vpim::Vcard.decode(open(file))

      cards.each do |card|
        uri = nil # TODO: UID support
        uri = "x-abuid:#{card['X-ABUID'].gsub('\\', '')}" if card['X-ABUID']
        resource = RDF::Resource.new(uri, :vcard)

        ## vCard name
        # <http://www.w3.org/TR/vcard-rdf#3> (3.4 Structured Properties)
        # <http://vpim.rubyforge.org/classes/Vpim/Vcard/Name.html>

        begin
          warn(card.name.inspect) if $DEBUG

          resource[:N] = RDF::Resource.new(nil, :vcard) do |n|
            [:Family, :Given, :Other, :Prefix, :Suffix].each do |prop|
              attr = prop == :Other ? :additional : prop.to_s.downcase.to_sym
              if value = card.name.send(attr)
                n[prop] = value unless value.empty?
              end
            end
          end
        rescue Vpim::InvalidEncodingError => e
          raise e # TODO
        end

        ## Basic properties
        # <http://www.w3.org/TR/vcard-rdf#3> (3.1 Basic Properties)

        BASICS.each do |name|
          card.values(name.to_s) do |value|
            # TODO: if it's an array, but only contains one entry, should we still create a Seq?
            resource[name] = value.respond_to?(:each) ?
              RDF::Seq.new(*value) : value.to_s
          end
        end

        ## Organization info
        # <http://www.w3.org/TR/vcard-rdf#3> (3.4 Structured Properties)
        # <http://www.w3.org/TR/vcard-rdf#5> (4th example)

        if orginfo = card.value('ORG')
          warn card.value('ORG').inspect if $DEBUG

          resource[:ORG] = RDF::Resource.new(nil, :vcard) do |org|
            orgname, *orgunits = orginfo
            org[:Orgname] = orgname
            org[:Orgunit] = RDF::Seq.new(*orgunits)
          end
        end

        ## Physical addresses
        # <http://www.w3.org/TR/vcard-rdf#3> (3.3 Properties with Attributes)
        # <http://www.w3.org/TR/vcard-rdf#3> (3.4 Structured Properties)
        # <http://www.w3.org/TR/vcard-rdf#5> (1st example)
        # <http://vpim.rubyforge.org/classes/Vpim/Vcard/Address.html>

        card.values('ADR') do |adr| # TODO
          warn adr.inspect if $DEBUG

          resource[:ADR] ||= []
          resource[:ADR] << RDF::Resource.new(nil, :vcard) do |node|
            # TODO: adr.delivery, adr.location, adr.preferred ?
            node[:Pobox]    = adr.pobox unless adr.pobox.empty?
            node[:Extadd]   = adr.extended unless adr.extended.empty?
            node[:Street]   = adr.street unless adr.street.empty?
            node[:Locality] = adr.locality unless adr.locality.empty?
            node[:Region]   = adr.region unless adr.region.empty?
            node[:Pcode]    = adr.postalcode unless adr.postalcode.empty?
            node[:Country]  = adr.country unless adr.country.empty?
          end
        end

        ## Telephone numbers
        # <http://www.w3.org/TR/vcard-rdf#3> (3.3 Properties with Attributes)
        # <http://www.w3.org/TR/vcard-rdf#5> (1st example)
        # <http://vpim.rubyforge.org/classes/Vpim/Vcard/Telephone.html>

        card.values('TEL') do |tel| # TODO
          warn tel.inspect if $DEBUG

          resource[:TEL] ||= []
          resource[:TEL] << RDF::Resource.new(nil, :rdf) do |node|
            node[:type] = []
            tel.location.each { |value| node[:type] << VCARD[value] }
            tel.capability.each { |value| node[:type] << VCARD[value] }
            node[:type] << VCARD[:pref] if tel.preferred
            node[:value] = tel.to_s
          end
        end

        ## E-mail addresses
        # <http://www.w3.org/TR/vcard-rdf#3> (3.2 Grouping and Ordering)
        # <http://www.w3.org/TR/vcard-rdf#3> (3.3 Properties with Attributes)
        # <http://www.w3.org/TR/vcard-rdf#5> (all examples)
        # <http://vpim.rubyforge.org/classes/Vpim/Vcard/Email.html>

        card.values('EMAIL') do |email| # TODO
          warn email.inspect if $DEBUG

          # TODO: put the EMAIL element into an Alt collection per 3.2?
          resource[:EMAIL] ||= []
          resource[:EMAIL] << RDF::Resource.new(nil, :rdf) do |node|
            node[:type] = []
            email.location.each { |value| node[:type] << VCARD[value] }
            email.format.each { |value| node[:type] << VCARD[value] }
            node[:type] << VCARD[:pref] if email.preferred
            # TODO: shouldn't the e-mail address be a mailto: URI reference?
            node[:value] = email.to_s
          end
        end

        # TODO: will need the appropriate test data to implement these.
        #card.value('UID')
        #card.value('URL')
        #card.values('AGENT') do |agent|; end
        #card.values('KEYS') do |key|; end
        #card.values('LOGO') do |logo|; end
        #card.values('PHOTO') do |photo|; end
        #card.values('SOUNDS') do |sound|; end

        # TODO: ?
        #card.each do |field|
        #  next if field.group || BASICS.include?(field.name.to_sym)
        #  #puts "name=#{field.name} value=#{field.value.inspect} group=#{field.group}"
        #  #field.each_param { |param, values| puts " #{param}=[#{values.join(", ")}]" }
        #end

        # TODO: this necessitates refactoring of the decoding machinery.
        #card.groups.sort.each do |group|
        #  resource[:GROUP] ||= []
        #  resource[:GROUP] << RDF::Seq.new do |seq|
        #    card.enum_by_group(group).each do |field|
        #      #puts field.inspect
        #      seq << field.value
        #    end
        #  end
        #end

        resources << resource
      end

      resources
    end

  end
end
