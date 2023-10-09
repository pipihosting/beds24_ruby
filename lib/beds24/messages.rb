module Beds24
  class Messages < Client
    # Get messages
    # params:
    #   room_id: The id of the room to return messages for.
    #   max_age: The maximum age (in days) of messages to return.
    #            If set to 3, messages from more than 3 days ago will not be included.
    def messages_by_room_id(room_id, max_age = 2)
      get("bookings/messages", {roomId: room_id, maxAge: max_age})
    end

    # DEPRECATED: use fetch_messages instead
    # Get messages
    # params:
    #  max_age: The maximum age (in days) of messages to return.
    #  source: The source of the messages to return. Possible values are: guest, host
    def messages(max_age = 2, source = "guest")
      get("bookings/messages", {maxAge: max_age, source: source})
    end

    def fetch_messages(options = {})
      get("bookings/messages", options)
    end

    # Send messages to a booking
    # params:
    #   booking_id: booking id
    #   message: message to send
    def send_message(booking_id, message)
      post("bookings/messages", [{bookingId: booking_id, message: message}])
    end

    def mark_read(*message_ids)
      return [] if message_ids.empty?
      post("bookings/messages", message_ids.map { |id| {id: id, read: true} })
    end
  end
end
