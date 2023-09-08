# frozen_string_literal: true

require_relative "beds24/version"
require_relative "beds24/client"
require_relative "beds24/authentication"
require_relative "beds24/bookings"
require_relative "beds24/messages"
require_relative "beds24/exception"

module Beds24
  class Error < StandardError; end
  # Your code goes here...
end
