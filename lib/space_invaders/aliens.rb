# frozen_string_literal: true

require 'gosu'
require_relative 'base/settings'
require_relative 'game_objects/alien'

module SpaceInvaders
  class Aliens
    HIT_ALIEN_SOUND = Settings::SOUNDS_PATH / 'alien_destroys.wav'
    INVASION_SOUND = Settings::SOUNDS_PATH / 'invasion.wav'

    DELAY_DRAW_MSEC = 1000
    attr_reader :changed, :last_killed

    def initialize(place_x, place_y)
      @aliens = []
      @place_x = place_x
      @place_y = place_y

      @destroy_sound = Gosu::Sample.new(HIT_ALIEN_SOUND)
      @invasion_sound = Gosu::Sample.new(INVASION_SOUND)

      @changed = false
      @move_direction = :right
      @move_step = Settings::ALIENS_MARGIN
      @last_move_time = Gosu.milliseconds
    end

    def setup
      alien_y = @place_y
      margin = Settings::ALIENS_MARGIN
      Settings::ALIENS_ROWS.times do |i|
        place_aliens_in_row(i, alien_y)
        alien_y += Settings::ALIENS_HEIGHT + margin
      end
    end

    def place_aliens_in_row(i, alien_y)
      alien_x = @place_x
      alien_path = Settings::ALL_ALIENS[i]
      Settings::ALIENS_PER_ROW.times do
        alien = Alien.new(alien_x, alien_y, alien_path)
        alien_x += alien.w + Settings::ALIENS_MARGIN
        @aliens << alien
      end
    end

    def draw
      @aliens.each(&:draw)
      @changed = false
    end

    def needs_redraw?
      return false if Gosu.milliseconds - @last_move_time < DELAY_DRAW_MSEC

      @aliens.each do |alien|
        move_x, move_y = next_move_coords_for(alien.x, alien.y)
        alien.set(move_x, move_y)
      end
      @invasion_sound.play
      next_move_direction
      @last_move_time = Gosu.milliseconds

      true
    end

    def find(x)
      @aliens
        .select { |alien| alien.area?(x) }
        .max_by(&:y)
    end

    def destroy(x, y)
      killed_alien = @aliens.find { |alien| alien.x == x && alien.y == y }
      @aliens.delete(killed_alien)
      @last_killed = killed_alien.type
      @destroy_sound.play(Settings::SOUNDS_VOLUME)
      @changed = true
    end

    private

    def next_move_coords_for(alien_x, alien_y)
      case @move_direction
      when :right
        [alien_x + @move_step, alien_y]
      when :left
        [alien_x - @move_step, alien_y]
      when :bottom
        [alien_x, alien_y + @move_step]
      end
    end

    def next_move_direction
      max_x_alien = @aliens.max_by(&:x).x
      min_x_alien = @aliens.min_by(&:x).x
      directions = {
        right: min_x_alien < @move_step,
        left: max_x_alien > Settings::WIDTH - Settings::ALIENS_WIDTH - @move_step
      }
      return if directions.values.all?(&:!)

      @move_direction = if @move_direction == :bottom
                          directions.key(true)
                        else
                          :bottom
                        end
    end
  end
end
