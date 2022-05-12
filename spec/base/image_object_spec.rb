# frozen_string_literal: true

require 'space_invaders/base/image_object'

RSpec.describe SpaceInvaders::ImageObject do
  let(:image_path) { File.join(Dir.pwd, 'spec', 'fixtures', 'files', 'ruby.png') }

  subject(:image_object) { described_class.new(0, 0, image_path) }

  describe '#set' do
    before { image_object.set(100, 200) }

    it 'updates x and y coordinates' do
      expect(image_object.x).to eql 100
      expect(image_object.y).to eql 200
    end
  end

  describe '#draw' do
    before do
      allow_any_instance_of(Gosu::Image).to receive(:draw).and_return nil
    end

    it 'draws an image at predefined coords' do
      expect_any_instance_of(Gosu::Image).to receive(:draw).with(0, 0, 0)
      image_object.draw
    end
  end
end
