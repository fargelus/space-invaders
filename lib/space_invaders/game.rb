# frozen_string_literal: true

require_relative 'scenes/main_scene'
require_relative 'scenes/game_over_scene'
require_relative 'scenes/menu_scene'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = Settings::WIDTH,
                   height = Settings::HEIGHT)
      super
      self.caption = Settings::CAPTION

      menu_scene = MenuScene.new(width: width, height: height, window: self)
      main_scene = MainScene.new(width: width, height: height, window: self)
      game_over_scene = GameOverScene.new(width: width, height: height, window: self)
      @current_scene = menu_scene
      @frames = [menu_scene, main_scene, game_over_scene]
    end

    def needs_redraw?
      @current_scene.needs_redraw?
    end

    def draw
      @current_scene.draw
    end

    def button_down(id)
      @current_scene.button_down(id)
    end

    def update
      @current_scene.update
      return unless @current_scene.need_change?

      next_scene_index = (@frames.index(@current_scene) + 1) % @frames.size
      @current_scene = @frames[next_scene_index]
    end
  end
end
