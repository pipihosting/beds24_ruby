RSpec.describe Beds24::Messages do
  let(:token) { "my_token" }
  subject(:messages) { Beds24::Messages.new(token, "my_refresh_token") }

  describe "#messages_by_room_id" do
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

      stub_request(:get, "https://beds24.com/api/v2/bookings/messages?roomId=1&maxAge=2")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "token" => "my_token"
          }
        ).to_return(status: 200, body: json.to_json, headers: {})
    end

    it "returns a parsed JSON response" do
      response = messages.messages_by_room_id(1)
      expect(response["success"]).to eq(true)
    end

    context "when return Unauthorized" do
      let(:body) { '{ "success": false, "code": 401, "error": "Token is missing" }' }
      before do
        stub_request(:get, "https://beds24.com/api/v2/bookings/messages?roomId=1&maxAge=2")
          .with(headers: {
            "Content-Type" => "application/json"
          })
          .to_return(status: 401, body: body)
      end

      it "raises an error" do
        expect { messages.messages_by_room_id(1) }.to raise_error(Beds24::Unauthorized)
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
        .to_return(status: 200, body: "[{\"success\": true}]", headers: {})
    end

    it "returns a parsed JSON response" do
      expect(send_message["success"]).to eq(true)
    end
  end

  describe "#mark_read" do
    let(:message_ids) { [123, 456] }
    subject(:mark_read) { messages.mark_read(*message_ids) }

    before do
      stub_request(:post, "https://beds24.com/api/v2/bookings/messages")
        .with(
          body: message_ids.map { |id| {id: id, read: true} },
          headers: {
            "Content-Type" => "application/json",
            "token" => token
          }
        )
        .to_return(status: 200, body: "[{\"success\": true},{\"success\": true}]", headers: {})
    end

    it "returns a parsed JSON response" do
      expect(mark_read).to eq([{"success" => true}, {"success" => true}])
    end

    context "params is empty" do
      subject(:mark_read) { messages.mark_read }

      it "returns an empty array" do
        expect(mark_read).to eq([])
      end
    end
  end
end
