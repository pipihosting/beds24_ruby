require "json"

module Beds24
  class Client
    BASE_URL = "https://beds24.com/api/v2"
    def initialize(token, refresh_token)
      @token = token
      @refresh_token = refresh_token
    end

    def get(uri, params = {}, headers = {})
      uri = URI("#{BASE_URL}/#{uri}")
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri, headers.merge("Content-Type" => "application/json", "token" => @token))

      response = http.request(request)

      case response
      when Net::HTTPSuccess
        JSON.parse response.body
      when Net::HTTPBadRequest
        raise "Bad request #{response.body}"
      when Net::HTTPUnauthorized
        raise "Unauthorized #{response.body}"
      else
        raise "Unexpected response #{response}, #{response.body}"
      end
    end

    def post(uri, body, headers = {})
      uri = URI("#{BASE_URL}/#{uri}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri, headers.merge("Content-Type" => "application/json", "token" => @token))
      request.body = body

      response = http.request(request)

      case response
      when Net::HTTPSuccess
        JSON.parse response.body
      when Net::HTTPBadRequest
        raise "Bad request #{response.body}"
      when Net::HTTPUnauthorized
        raise "Unauthorized #{response.body}"
      else
        raise "Unexpected response #{response}, #{response.body}"
      end
    end
  end
end
