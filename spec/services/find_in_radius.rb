# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FindInRadius do
  context 'valid params' do
    let(:params) do
      {
        lat: rand(10.1...70.1).floor(6),
        lon: rand(10.1...70.1).floor(6),
        range: 1000
      }
    end

    let(:key) { "#{params[:lat].ceil(3)}/#{params[:lon].ceil(3)}/#{params[:range]}" }

    let!(:correct_point) { Fabricate(:point, lat: params[:lat], lon: params[:lon], description: 'correct') }
    let!(:incorrect_point) { Fabricate(:point, description: 'incorrect') }

    it 'returns point' do
      result = described_class.new.call(**params)

      expect(result.success?).to be_truthy
      expect(result.success.map(&:id)).to eq [correct_point.id]
    end

    it 'write in cache' do
      expect(Rails.cache.read(key)).to be_nil

      described_class.new.call(**params)

      expect(Rails.cache.read(key)).to eq [correct_point]
    end

    context 'read from cache' do
      before do
        Rails.cache.write(key, [correct_point])
      end

      it 'returns points' do
        result = described_class.new.call(**params)

        expect(Point).not_to receive(:where)
        expect(result.success?).to be_truthy
        expect(result.success.map(&:id)).to eq [correct_point.id]
      end
    end
  end

  context 'invalid params' do
    let(:params) { { range: 1000 } }

    it 'returns point' do
      result = described_class.new.call(**params)

      expect(result.failure?).to be_truthy
    end
  end
end
