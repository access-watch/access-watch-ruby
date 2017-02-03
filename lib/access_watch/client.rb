require "json/ext"
require "net/http"
require "uri"
require "openssl"

module AccessWatch
  class Client
    attr_reader :api_key, :api_secret, :api_endpoint, :api_timeout

    def initialize(options)
      @api_secret = options[:api_secret]
      @api_timeout = options[:api_timeout] || 1
      @api_key = options[:api_key] or raise "AccessWatch api_key is mandatory."
      @api_endpoint = options[:api_endpoint] || "https://access.watch/api/1.0/"
    end

    def post(path, data)
      uri = URI(api_endpoint + path)
      post = Net::HTTP::Post.new(uri.path, default_headers)
      post.body = data.to_json
      resp = http(uri).request(post)
    end

    def get(path, params = nil)
      uri = URI.parse(api_endpoint + path)
      uri.query = URI.encode_www_form(params) if params
      request = Net::HTTP::Get.new(uri.request_uri, default_headers)
      response = http(uri).request(request)
      response.body
    end

    def default_headers
      {
        "Api-Key" => api_key,
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
    end

    private

    HTTPS = "https".freeze
    CERTIFICATE_AUTHORITIES_PATH = File.expand_path("../../../cacert.pem", __FILE__)

    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = api_timeout
      if uri.scheme == HTTPS
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.ca_file = CERTIFICATE_AUTHORITIES_PATH
        http.use_ssl = true
      end
      http
    end
  end
end
