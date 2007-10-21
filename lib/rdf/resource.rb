module RDF
  class Resource

    attr_reader :uri
    attr_reader :data
    attr_writer :ns

    def initialize(uri = nil, ns = :dc, &block)
      @uri = uri
      @data = {}
      @ns = Namespace[ns.to_sym] rescue Namespace.new(ns.to_s)
      block.call(self) if block_given?
    end

    def namespaces
      Namespace.prefixes # FIXME
    end

    def anonymous?
      @uri.nil?
    end

    def type=(value)
      data[Namespace[:rdf].type.uri] = value
    end

    def [](name)
      raise ArgumentError.new('wrong number of arguments') if args.empty?

      data[@ns[name.to_s.gsub('_', '-')].uri]
    end

    def []=(*args)
      raise ArgumentError.new('wrong number of arguments') unless (2..3).include?(args.length)

      if args.length == 2  # r[:suffix] = value
        name, value = args
        uri = @ns[name.to_s.gsub('_', '-')].uri
      else                 # r[:ns, :suffix] = value
        ns, name, value = args
        uri = Namespace[ns][name.to_s.gsub('_', '-')].uri
      end
      data[uri] = value
    end

    def method_missing(method, *args, &block)
      #suffix = method.to_s.gsub(/[=\?]+$/, '').gsub('_', '-').to_sym
      self[method.to_s.gsub('_', '-')]
    end

    def qname
      if uri =~ /([\w\d\-_]+)$/
        suffix = $1
        if prefix = Namespace.prefix_for(uri[0...-suffix.length])
          "#{prefix}:#{suffix}"
        else
          nil
        end
      end
    end

    def to_s
      "<#{qname || uri}>"
    end

    def inspect
      "#<#{self.class} #{qname || uri}>"
    end

  end
end
