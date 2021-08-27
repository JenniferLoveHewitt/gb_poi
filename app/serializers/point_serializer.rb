# frozen_string_literal: true

class PointSerializer < ActiveModel::Serializer
  attributes :lat, :lon, :description
end
