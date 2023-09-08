require "net/http"

module Beds24
  class Authentication < Client
    # Get a refresh token using an invite code
    #
    # Note: Refresh tokens do not expire so long as they have been used within the past 30 days
    # Codes can be generated here https://beds24.com/control3.php?pagetype=apiv2
    # Possible scopes are: bookings bookings-personal bookings-financial inventory properties accounts channels
    def setup(code, device_name = nil)
      get("authentication/setup", {}, {"code" => code, "deviceName" => device_name}, false)
    end

    # Get an authentication token using a refresh token
    def token(refresh_token = @refresh_token)
      get("authentication/token", {}, {"refreshToken" => refresh_token}, false)
    end

    # Delete a refresh token
    def delete(refresh_token = @refresh_token)
      # TODO
    end

    # Get information about a token and diagnostics
    def details(token = @token)
      get("authentication/details", {token: token})
    end
  end
end
