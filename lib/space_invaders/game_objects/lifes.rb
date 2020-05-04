# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class Lifes < GameObject
    IMAGE_PATH = Settings::IMAGES_PATH / 'heart.png'

    def initialize(coord_x, coord_y)
      super coord_x, coord_y, IMAGE_PATH
    end

    def draw(amount)
      coord_x = @x
      amount.times do
        @figure.draw(coord_x, @y, 0)
        coord_x += w + Settings::LIFES_MARGIN
      end
    end
  end
end
