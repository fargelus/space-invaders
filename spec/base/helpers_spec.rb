# frozen_string_literal: true

require 'space_invaders/base/helpers'
require 'ostruct'

RSpec.describe SpaceInvaders::Helpers do
  include SpaceInvaders::Helpers

  let(:collection) do
    [
      OpenStruct.new(x: 2, y: 35),
      OpenStruct.new(x: 50, y: 0),
      OpenStruct.new(x: -100, y: 200)
    ]
  end

  describe '#max_x_coord' do
    subject { max_x_coord(collection) }

    it 'returns max x value' do
      expect(subject).to eql 50
    end
  end

  describe '#min_x_coord' do
    subject { min_x_coord(collection) }

    it 'returns min x value' do
      expect(subject).to eql(-100)
    end
  end
end
