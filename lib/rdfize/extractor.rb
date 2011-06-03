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
        @extractors ||= {}
        @extractors.each_value do |values|
          values.each(&block)
        end
      end
      enum_for(:each)
    end

    ##
    # @param  [Hash{Symbol => Object}] options
    def initialize(options = {})
      @options = options.dup
    end
  end # Extractor
end # RDFize
