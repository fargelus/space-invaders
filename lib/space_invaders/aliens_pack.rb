# frozen_string_literal: true

require 'pathname'
require_relative 'settings/settings'

module SpaceInvaders
  class AliensPack
    def initialize
      @pack = all_aliens
    end

    private

    def all_aliens
      Pathname.new(AssetsSettings::ALIENS_DIR).children.map { |file| file }
    end
  end

  class DefaultAliensPack < AliensPack
    def initialize
      super
      @returned = 0
    end

    def next_alien
      i = @returned % @pack.size
      @returned += 1
      @pack[i]
    end
  end
end

SpaceInvaders::AliensPack.new
