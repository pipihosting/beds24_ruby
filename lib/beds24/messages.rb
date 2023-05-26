module Beds24
  class Messages < Client
    def initialize(token)
      @token = token
    end

    # Get messages
    # params:
    #   room_ids: array of room ids
    #   max_age: The maximum age (in days) of messages to return.
    #            If set to 3, messages from more than 3 days ago will not be included.
    def messages_by_room_ids(room_ids, max_age = 2)
      get("bookings/messages", {roomId: room_ids, maxAge: max_age}, {token: @token})
    end

    def messages(max_age = 2)
      get("bookings/messages", {maxAge: max_age}, {token: @token})
    end

    # Send messages to a booking
    # params:
    #   booking_id: booking id
    #   message: message to send
    def send_message(booking_id, message)
      post("bookings/messages", [{bookingId: booking_id, message: message}], {token: @token})
    end
  end
end
