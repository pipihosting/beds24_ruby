RSpec.describe Beds24::Messages do
  let(:token) { "my_token" }
  subject(:messages) { Beds24::Messages.new(token, "my_refresh_token") }

  describe "#messages_by_room_ids" do
    before do
      # json response
      json = {
        success: true,
        type: "message",
        count: 0,
        pages: {
          nextPageExists: true,
          nextPageLink: "example.com/api/example?page=2"
        },
        data: [
          {
            id: 0,
            bookingId: 0,
            read: true,
            message: "string",
            attachment: "string",
            attachmentName: "string",
            attachmentMimeType: "image",
            roomId: 0,
            propertyId: 0,
            time: "2023-05-25T22:30:20.314Z",
            source: "host"
          }
        ]
      }

      stub_request(:get, "https://beds24.com/api/v2/bookings/messages?roomId=1&roomId=2&roomId=3&maxAge=2")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "token" => "my_token"
          }
        )
        .to_return(status: 200, body: json.to_json, headers: {})
    end

    it "returns a parsed JSON response" do
      response = messages.messages_by_room_ids([1, 2, 3])
      expect(response["success"]).to eq(true)
    end

    context "when return Unauthorized" do
      let(:body) { '{ "success": false, "code": 401, "error": "Token is missing" }' }
      before do
        stub_request(:get, "https://beds24.com/api/v2/bookings/messages?roomId=1&roomId=2&roomId=3&maxAge=2")
          .to_return(status: 401, body: body)
      end

      it "raises an error" do
        expect { messages.messages_by_room_ids([1, 2, 3]) }.to raise_error("Unauthorized #{body}")
      end
    end
  end

  describe "#send_message" do
    let(:message) { "my_message" }
    let(:booking_id) { 123 }
    subject(:send_message) { messages.send_message(booking_id, message) }

    before do
      stub_request(:post, "https://beds24.com/api/v2/bookings/messages")
        .with(
          body: [{"bookingId" => booking_id, "message" => message}],
          headers: {
            "Content-Type" => "application/json",
            "token" => token
          }
        )
        .to_return(status: 200, body: '[{"success": true}]', headers: {})
    end

    it "returns a parsed JSON response" do
      expect(send_message.first["success"]).to eq(true)
    end
  end
end
