# frozen_string_literal: true

require 'gosu'

module SpaceInvaders
  class GameObject
    attr_reader :x, :y, :w, :h

    def initialize(x, y, image_path)
      @x = x
      @y = y
      @figure = Gosu::Image.new(image_path.to_s)
      @w = @figure.width
      @h = @figure.height
    end

    def set(x, y)
      @x = x
      @y = y
    end

    def draw(z = 0)
      @figure.draw(@x, @y, z)
    end
  end
end
