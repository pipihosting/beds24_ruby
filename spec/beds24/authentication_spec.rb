RSpec.describe Beds24::Authentication do
  let(:code) { "my_code" }
  let(:device_name) { "my_device" }
  subject(:authentication) { Beds24::Authentication.new }

  describe "#setup" do
    before do
      stub_request(:get, "https://beds24.com/api/v2/authentication/setup")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "code" => code,
            "deviceName" => device_name
          }
        )
        .to_return(status: 200, body: '{"token": "string", "expiresIn": 3600, "refreshToken": "string"}', headers: {})
    end

    it "returns a parsed JSON response" do
      response = authentication.setup(code, device_name)
      expect(response["token"]).to eq("string")
    end

    context "when the response is not successful" do
      let(:body) { '{ "success": false, "type": "error", "code": 400, "error": "string" }' }
      before do
        stub_request(:get, "https://beds24.com/api/v2/authentication/setup")
          .to_return(status: 400, body: body)
      end

      it "raises an error" do
        expect { authentication.setup(code, device_name) }.to raise_error("Bad request #{body}")
      end
    end
  end

  describe "#token" do
    before do
      stub_request(:get, "https://beds24.com/api/v2/authentication/token")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "refreshToken" => "my_refresh_token"
          }
        )
        .to_return(status: 200, body: '{"token": "string", "expiresIn": 3600}', headers: {})
    end

    it "returns a parsed JSON response" do
      response = authentication.token("my_refresh_token")
      expect(response["token"]).to eq("string")
    end

    context "when the response is not successful" do
      let(:body) { '{"success": false, "type": "error", "code": 400, "error": "string"}' }
      before do
        stub_request(:get, "https://beds24.com/api/v2/authentication/token")
          .to_return(status: 400, body: body)
      end

      it "raises an error" do
        expect { authentication.token("my_refresh_token") }
          .to raise_error("Bad request #{body}")
      end
    end
  end

  describe "#details" do
    before do
      # mock request
      stub_request(:get, "https://beds24.com/api/v2/authentication/details")
        .with(query: {token: "my_token"})
        .to_return(status: 200, body: '{"validToken": "true", "token": {"expiredsIn": 0}}', headers: {})
    end

    it "returns a parsed JSON response" do
      response = authentication.details("my_token")
      expect(response["validToken"]).to eq("true")
    end
  end
end
