# frozen_string_literal: true

require 'securerandom'

default_value = { lat: 50.123456, lon: 40.123456 }

(1..20).each do |i|
  Point.create(
    lat: default_value[:lat] + i,
    lon: default_value[:lon] + i,
    description: SecureRandom.urlsafe_base64(4)
  )
end
