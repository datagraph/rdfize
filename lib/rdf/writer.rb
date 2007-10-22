module RDF
  class Writer

    def initialize(stream = $stdout)
      @stream = stream
      @nodes = {}
      @node_id = 0
    end

    def register!(resource)
      return false if @nodes[resource] # already seen it
      @nodes[resource] = resource.uri || "_:n#{@node_id += 1}"
    end

    def <<(resource)
      register!(resource) && write(resource)
    end

    def write(resource)
      nodes = []

      subject_uri = @nodes[resource]
      resource.data.each do |predicate, objects|
        [objects].flatten.each do |object|
          if object.respond_to?(:uri)
            nodes << object if register!(object)
            object_uri = @nodes[object]
            @stream.puts "<#{subject_uri}> <#{predicate}> <#{object_uri}> ."
          else
            @stream.puts "<#{subject_uri}> <#{predicate}> #{object} ."
          end
        end
      end

      nodes.each { |node| write node }
    end

  end
end
