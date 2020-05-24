# frozen_string_literal: true

module SpaceInvaders
  class Lifes < GameObject
    def initialize(coord_x, coord_y)
      super coord_x, coord_y, Settings::IMAGES_PATH / 'heart.png'
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
