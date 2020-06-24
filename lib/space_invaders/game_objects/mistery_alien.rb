# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../base/timer'

module SpaceInvaders
  class MisteryAlien < Alien
    include Settings

    DELAY_DRAW_MSEC = 600
    MOVING_REDRAW_MSEC = 30
    MISTERY_SOUND = SOUNDS_PATH / 'mistery.wav'

    attr_reader :moving

    def initialize(coord_y)
      super -MISTERY_WIDTH, coord_y, ALIENS_PATH_TO_TYPE.key(:mistery)

      @type = :mistery
      @moving = false
      @move_direction = :right
      @opposite_directions = { left: :right, right: :left }
      @moving_sound = Gosu::Sample.new(MISTERY_SOUND)
    end

    def draw
      super
      move if Timer.overtime?(MOVING_REDRAW_MSEC)
    end

    def needs_redraw?
      return @moving if @moving

      @moving = Timer.overtime?(DELAY_DRAW_MSEC)
    end

    private

    def move
      step = ALIENS_MARGIN
      step = -step if @move_direction == :left
      @x += step
      @moving_sound.play
      on_last_moving_step
    end

    def on_last_moving_step
      if @x + ALIENS_MARGIN < WIDTH + MISTERY_WIDTH && @x >= -MISTERY_WIDTH
        return
      end

      @move_direction = @opposite_directions[@move_direction]
      @moving = false
    end
  end
end
