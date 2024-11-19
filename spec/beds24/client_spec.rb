require "spec_helper"

RSpec.describe Beds24::Client do
  let(:token) { "test_token" }
  let(:refresh_token) { "test_refresh_token" }
  let(:client) { described_class.new(token, refresh_token) }

  describe "#get" do
    let(:path) { "test_path" }
    let(:response_body) { { data: "test" }.to_json }

    before do
      stub_request(:get, "#{Beds24::Client::BASE_URL}/#{path}")
        .with(
          headers: {
            'Content-Type'=>'application/json',
            'token'=>'test_token'
          }
        )
        .to_return(status: 200, body: response_body)
    end

    it "makes a GET request with token" do
      result = client.get(path)
      expect(result).to eq({ "data" => "test" })
    end

    context "with array parameters" do
      let(:params) { { status: ["new", "confirmed"] } }

      before do
        stub_request(:get, "#{Beds24::Client::BASE_URL}/#{path}")
          .with(
            query: "status=new&status=confirmed",
            headers: {
              'Content-Type'=>'application/json',
              'token'=>'test_token'
            }
          )
          .to_return(status: 200, body: response_body)
      end

      it "supports array parameters" do
        result = client.get(path, params)
        expect(result).to eq({ "data" => "test" })
      end
    end

    context "when response has error" do
      context "with unauthorized error" do
        before do
          stub_request(:get, "#{Beds24::Client::BASE_URL}/#{path}")
            .to_return(status: 401, body: { code: 401, error: "Unauthorized" }.to_json)
        end

        it "raises Unauthorized error" do
          expect { client.get(path) }.to raise_error(Beds24::Unauthorized, "Unauthorized")
        end
      end
    end
  end

  describe "#post" do
    let(:path) { "test_path" }
    let(:body) { { name: "test" } }
    let(:response_body) { { data: "test" }.to_json }

    before do
      stub_request(:post, "#{Beds24::Client::BASE_URL}/#{path}")
        .with(
          body: body.to_json,
          headers: {
            'Content-Type'=>'application/json',
            'token'=>'test_token'
          }
        )
        .to_return(status: 200, body: response_body)
    end

    it "makes a POST request with token" do
      result = client.post(path, body)
      expect(result).to eq({ "data" => "test" })
    end

    context "when response has error" do
      context "with unauthorized error" do
        before do
          stub_request(:post, "#{Beds24::Client::BASE_URL}/#{path}")
            .with(
              body: body.to_json,
              headers: {
                'Content-Type'=>'application/json',
                'token'=>'test_token'
              }
            )
            .to_return(status: 401, body: { code: 401, error: "Unauthorized" }.to_json)
        end

        it "raises Unauthorized error" do
          expect { client.post(path, body) }.to raise_error(Beds24::Unauthorized, "Unauthorized")
        end
      end
    end
  end
end
