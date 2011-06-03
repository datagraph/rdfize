require 'curb' # @see http://rubygems.org/gems/curb

module RDFize
  class Client
    ##
    # @param  [Hash{Symbol => Object}] options
    # @option options [String]  :user_agent ("RDFize/x.y.z")
    # @option options [Integer] :timeout    (30)
    def initialize(options = {})
      @curl = Curl::Easy.new do |c|
        c.on_header(&method(:on_header))
        c.on_body(&method(:on_body))
        c.on_progress(&method(:on_progress))
        c.on_complete(&method(:on_complete))
        c.on_success(&method(:on_success))
        c.on_failure(&method(:on_failure))

        c.follow_location = true
        c.max_redirects   = 5
        c.autoreferer     = true
        c.connect_timeout = (options[:timeout] || 30).to_i
        c.timeout         = (options[:timeout] || 30).to_i
        c.ssl_verify_host = false
        c.ssl_verify_peer = false
        c.enable_cookies  = true
        c.verbose         = true if options[:debug]

        c.useragent       = (options[:user_agent] || "RDFize/#{VERSION}").to_s
        c.headers['Accept'] = '*/*' # FIXME
      end
    end

    ##
    # @return [Curl::Easy]
    attr_reader :curl

    ##
    # @param  [String, #to_s] url
    # @param  [Hash{Symbol => Object}] options
    # @return [void]
    def fetch(url, options = {})
      @curl.url = url.to_s # FIXME: escaping
      @curl.http_get
      return self
    end

  protected

    ##
    # @param  [String] data
    # @return [Integer]
    def on_header(data)
      # TODO
      data.bytesize
    end

    ##
    # @param  [String] data
    # @return [Integer]
    def on_body(data)
      # TODO
      data.bytesize
    end

    ##
    # @param  [Float] dl_total
    # @param  [Float] dl_now
    # @return [void]
    def on_progress(dl_total, dl_now, ul_total, ul_now)
      # TODO
    end

    ##
    # @param  [Curl::Easy] handle
    # @return [void]
    def on_complete(handle)
      # TODO
    end

    ##
    # @param  [Curl::Easy] handle
    # @return [void]
    def on_success(handle)
      # TODO
    end

    ##
    # @param  [Curl::Easy] handle
    # @param  [Curl::Err] code
    # @return [void]
    def on_failure(handle, code)
      # TODO
    end
  end # Client
end # RDFize
