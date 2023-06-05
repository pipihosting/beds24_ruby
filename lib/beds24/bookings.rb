module Beds24
  class Bookings < Client
    def bookings(params = {})
      puts "bookings #{params}"
      get("bookings", params)
    end

    def booking(booking_id)
      get("bookings", {id: booking_id})
    end
  end
end
