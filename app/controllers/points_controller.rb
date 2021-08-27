# frozen_string_literal: true

class PointsController < ApplicationController
  def index
    FindInRadius.new.call(points_params) do |m|
      m.success do |points|
        render json: points, each_serializer: PointSerializer, status: :ok
      end

      m.failure do |error|
        render status: 422, json: { error: error }
      end
    end
  end

  private

  def points_params
    params.permit(:lat, :lon, :range)
  end
end
