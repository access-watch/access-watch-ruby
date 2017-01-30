require "json/ext"
require "net/http"
require "uri"
require "openssl"

module AccessWatch
  class Client
    attr_reader :api_key, :api_secret, :api_endpoint

    def initialize(options)
      @api_secret = options[:api_secret]
      @api_key = options[:api_key] or raise "AccessWatch api_key is mandatory."
      @api_endpoint = options[:api_endpoint] || "https://access.watch/api/1.0/"
    end

    HTTPS = "https".freeze
    CERTIFICATE_AUTHORITIES_PATH = File.expand_path("../../../cacert.pem", __FILE__)

    def post(path, data)
      uri = URI(api_endpoint + path)
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == HTTPS
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.ca_file = CERTIFICATE_AUTHORITIES_PATH
        http.use_ssl = true
      end

      post = Net::HTTP::Post.new(uri.path, default_headers)
      post.body = data.to_json
      resp = http.request(post)
    end

    def default_headers
      {
        "Api-Key" => api_key,
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
    end
  end
end
