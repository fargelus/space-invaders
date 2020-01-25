# frozen_string_literal: true

require 'gosu'
require_relative 'settings'
require_relative 'game_object'

module SpaceInvaders
  class Alien < GameObject
    DEFAULT_ALIEN = Settings::ALIENS_DIR / 'invader_0.png'

    def initialize(x = 0, y = 0, alien_path = DEFAULT_ALIEN)
      super x, y, alien_path
      @init_draw = true
    end

    def needs_redraw?
      result = @init_draw
      @init_draw = false
      result
    end
  end
end
