module RDFize
  class Extractor
    extend Enumerable

    ##
    # @yield  [klass]
    # @yieldparam   [Class] klass
    # @yieldereturn [void] ignored
    # @return [Enumerator]
    def self.each(&block)
      if block_given?
        @@classes ||= {}
        @@classes.values.uniq.each(&block)
      end
      enum_for(:each)
    end

    ##
    # @param  [Hash{Symbol => Object}] options
    def initialize(options = {})
      @options = options.dup
    end

  protected

    ##
    # @param  [String] type
    # @param  [Hash{Symbol => Object}] options
    # @option options [Float] :weight (0.1)
    # @return [void]
    def self.content_type(type, options = {})
      type = type.to_s
      @@classes ||= {}
      @@classes[type] = self
      @@weights ||= {}
      @@weights[type] = Float(options[:weight] || 0.1)
    end
  end # Extractor
end # RDFize
