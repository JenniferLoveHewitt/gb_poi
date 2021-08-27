# frozen_string_literal: true

require 'dry/transaction'
require 'dry/schema'

class FindInRadius
  include Dry::Transaction

  PointSchema = Dry::Schema.Params do
    required(:lat).filled(:float)
    required(:lon).filled(:float)

    required(:range).maybe(:integer)
  end

  step :validate
  step :find_points

  private

  def validate(input)
    schema = PointSchema.call(input.to_h)

    if schema.success?
      Success(input)
    else
      Failure(schema.errors)
    end
  end

  def find_points(input)
    key = "#{input[:lat].to_f.ceil(3)}/#{input[:lon].to_f.ceil(3)}/#{input[:range]}"
    points = Rails.cache.read(key)

    return Success(points) if points

    points =
      Point.where(
        'earth_box(ll_to_earth(?, ?), ?/1.609) @> ll_to_earth(lat, lon)',
        input[:lat],
        input[:lon],
        input[:range].to_i
      )

    Rails.cache.write(key, points, expires_at: 5.minutes)

    Success(points)
  end
end
