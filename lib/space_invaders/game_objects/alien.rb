# frozen_string_literal: true

require 'gosu'
%w[settings game_object].each do |fn|
  require_relative "../base/#{fn}"
end

module SpaceInvaders
  class Alien < GameObject
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
