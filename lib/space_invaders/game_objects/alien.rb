# frozen_string_literal: true

require 'gosu'
require_relative '../settings'
require_relative 'basic_object'

module SpaceInvaders
  class Alien < BasicObject
    DEFAULT_ALIEN = Settings::ALIENS_DIR / 'invader_0.png'

    def initialize(x = 0, y = 0, alien_path = DEFAULT_ALIEN)
      super x, y, alien_path
    end

    def area?(x)
      @x < x && @x + @w + Settings::ALIENS_MARGIN > x
    end

    def start_y
      @y + @h
    end
  end
end
