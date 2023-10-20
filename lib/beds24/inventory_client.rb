module Beds24
  class InventoryClient < Client
    def update(params = {})
      post("inventory/rooms/calendar", params)
    end

    def room_calendar(params = {})
      get("inventory/rooms/calendar", params)
    end
  end
end
