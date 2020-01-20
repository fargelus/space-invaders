# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  class Alien < GameObject
    @@amount = 0

    def initialize(x = 0, y = 0)
      prefix = @@amount % Settings::INVADERS_TYPES_COUNT
      alien_path = Settings::IMAGES_PATH / "invader_#{prefix}.png"

      super x, y, alien_path.to_s
      @@amount += 1
      @init_draw = true
    end

    def needs_redraw?
      result = @init_draw
      @init_draw = false
      result
    end
  end
end
