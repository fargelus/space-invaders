# frozen_string_literal: true

require_relative 'settings'
require_relative 'game_object'

module SpaceInvaders
  class GameScene
    def initialize(width:, height:, window:)
      @width = width
      @height = height
      @window = window
      @bg = GameObject.new(0, 0, Settings::IMAGES_PATH / 'space.png')
    end

    def button_down(id)
      @window.close if id == Gosu::KbEscape
    end

    def draw
      @bg.draw
    end

    def update; end
  end
end
