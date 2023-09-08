require "json"
require "faraday"

module Beds24
  class Client
    BASE_URL = "https://beds24.com/api/v2"
    def initialize(token, refresh_token)
      @token = token
      @refresh_token = refresh_token
    end

    def get(path, params = {}, headers = {}, with_token = true)
      to_json(conn.get(uri(path: path)) do |req|
        req.headers = with_token ? headers_with_token.merge(headers) : headers
        req.params = params
      end&.body)
    end

    def post(path, body, headers = {})
      body = conn.post(uri(path: path)) do |req|
        req.headers = headers.merge("Content-Type" => "application/json", "token" => @token)
        req.body = body.to_json
      end&.body

      to_json(body)
    end

    private

    def headers_with_token
      {
        "Content-Type" => "application/json",
        "token" => @token
      }
    end

    def to_json(body)
      return unless body
      data = JSON.parse(body)

      # if json is a array
      if data.is_a?(Array)
        return process_json_array(data)
      end

      code = data["code"]

      if code == 401
        raise Beds24::Unauthorized.new(data["error"])
      elsif code == 400
        raise Beds24::BadRequest.new(data["error"])
      elsif data["success"] != false
        data
      else
        raise Beds24::Error.new(data["error"])
      end
    end

    def process_json_array(data)
      if data.is_a?(Array) && data.size == 1
        data = data.first
      end
      data
    end

    def conn
      ::Faraday.new do |f|
        f.options[:timeout] = 10
      end
    end

    def uri(path:)
      "#{BASE_URL}/#{path}"
    end
  end
end
