RSpec.describe Beds24::Bookings do
  let(:token) { "my_token" }
  subject(:bookings) { Beds24::Bookings.new(token, "my_refresh_token") }

  describe "#bookings" do
    let(:params) { {"test" => "test"} }
    let(:response) { {"success" => "true"} }

    before do
      allow(bookings).to receive(:get).with("bookings", params).and_return(response)
    end

    it "returns bookings" do
      expect(bookings.bookings(params)).to eq response
    end
  end
end
