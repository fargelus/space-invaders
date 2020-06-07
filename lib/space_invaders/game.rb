# frozen_string_literal: true

require_relative 'scenes/game_scene'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION

      @game_scene = GameScene.new(width: width, height: height, window: self)
    end

    def draw
      @game_scene.draw
    end

    def button_down(id)
      @game_scene.button_down(id)
    end

    def update
      @game_scene.update
    end
  end
end
