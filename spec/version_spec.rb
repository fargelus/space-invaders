# frozen_string_literal: true

require 'space_invaders/version'

RSpec.describe SpaceInvaders do
  it 'has a version number' do
    expect(SpaceInvaders::VERSION).not_to be nil
  end
end
