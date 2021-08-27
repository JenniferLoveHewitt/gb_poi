# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PointsController do
  describe 'GET index' do
    context 'correct params' do
      let(:params) do
        {
          lat: rand(10.1...70.1).floor(6),
          lon: rand(10.1...70.1).floor(6),
          range: 1000
        }
      end

      let!(:correct_point) { Fabricate(:point, lat: params[:lat], lon: params[:lon], description: 'correct') }
      let!(:incorrect_point) { Fabricate(:point, description: 'incorrect') }

      it 'returns :ok' do
        get :index, params: params

        expect(response.status).to eq 200

        body = JSON.parse(response.body)

        expect(body.length).to eq 1
        expect(body.first['description']).to eq correct_point.description
      end
    end

    context 'incorrect params' do
      let(:params) { { range: 1000 } }

      it 'returns error' do
        get :index, params: params

        expect(response.status).to eq 422

        expect(JSON.parse(response.body)['error']).not_to be_nil
      end
    end
  end
end
