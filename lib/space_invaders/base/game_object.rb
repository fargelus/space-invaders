# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class GameObject
    attr_reader :x, :y, :w, :h

    def initialize(coord_x, coord_y, image_path)
      @x = coord_x
      @y = coord_y
      @figure = Gosu::Image.new(image_path.to_s)
      @w = @figure.width
      @h = @figure.height
    end

    def set(coord_x, coord_y)
      @x = coord_x
      @y = coord_y
    end

    def draw
      @figure.draw(@x, @y, 0)
    end
  end
end
