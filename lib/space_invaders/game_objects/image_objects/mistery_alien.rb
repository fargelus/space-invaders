# frozen_string_literal: true

require 'gosu'
require_relative '../../base/settings'
require_relative '../../base/timer'

module SpaceInvaders
  class MisteryAlien < Alien
    include Settings

    MOVING_REDRAW_MSEC = 30
    MISTERY_SOUND = SOUNDS_PATH / 'mistery.wav'
    INITIAL_MOVE_DIRECTION = :right
    MISTERY_INITIAL_COORD_X = -MISTERY_WIDTH

    attr_reader :on_start

    def initialize(coord_y)
      super MISTERY_INITIAL_COORD_X, coord_y, ALIENS_PATH_TO_TYPE.key(:mistery)

      @type = :mistery
      @move_direction = INITIAL_MOVE_DIRECTION
      @opposite_directions = { left: :right, right: :left }
      @moving_sound = Gosu::Sample.new(MISTERY_SOUND)
      @on_start = true
    end

    def draw
      super

      @on_start = false
      return unless Timer.overtime?(MOVING_REDRAW_MSEC)

      step = ALIENS_MARGIN
      step = -step if @move_direction == :left
      @x += step
      @moving_sound.play
      on_last_moving_step
    end

    private

    def on_last_moving_step
      return if @x + ALIENS_MARGIN < WIDTH + MISTERY_WIDTH && @x >= -MISTERY_WIDTH

      @move_direction = @opposite_directions[@move_direction]
      @on_start = @move_direction == INITIAL_MOVE_DIRECTION
    end
  end
end
