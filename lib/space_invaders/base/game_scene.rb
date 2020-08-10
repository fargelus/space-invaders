# frozen_string_literal: true

require_relative 'settings'
require_relative 'image_object'

module SpaceInvaders
  class GameScene
    def initialize(width:, height:, window:)
      @width = width
      @height = height
      @window = window
      @bg = ImageObject.new(0, 0, Settings::IMAGES_PATH / 'space.png')
      @change = false
    end

    def button_down(id)
      @window.close if id == Gosu::KbEscape
    end

    def draw
      @bg.draw
    end

    def needs_change?
      @change
    end

    def update; end

    def prepare_scene
      @change = false
    end
  end
end
