require "net/http"

module Beds24
  class Authentication < Client
    # Get a refresh token using an invite code
    def setup(code, device_name = nil)
      get("authentication/setup", {}, {code: code, deviceName: device_name})
    end

    # Get an authentication token using a refresh token
    def token(refresh_token)
      get("authentication/token", {}, {refreshToken: refresh_token})
    end

    # Delete a refresh token
    def delete(refresh_token)
      # TODO
    end

    # Get information about a token and diagnostics
    def details(token)
      get("authentication/details", {token: token})
    end
  end
end
