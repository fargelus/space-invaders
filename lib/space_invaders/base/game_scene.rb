# frozen_string_literal: true

module SpaceInvaders
  class GameScene
    def initialize(width:, height:, window:)
      @width = width
      @height = height
      @window = window
    end

    def button_down(id)
      @window.close if id == Gosu::KbEscape
    end

    def update; end
  end
end
