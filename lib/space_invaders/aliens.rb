# frozen_string_literal: true

require 'gosu'
require_relative 'base/settings'
require_relative 'game_objects/alien'

module SpaceInvaders
  class Aliens
    HIT_ALIEN_SOUND = Settings::SOUNDS_PATH / 'alien_destroys.wav'
    INVASION_SOUND = Settings::SOUNDS_PATH / 'invasion.mp3'

    DELAY_DRAW_MSEC = 700
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

    def place_aliens_in_row(index, alien_y)
      alien_x = @place_x
      alien_path = Settings::ALL_ALIENS[index]
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
        alien.on_move
      end
      @invasion_sound.play
      next_move_direction
      @last_move_time = Gosu.milliseconds
    end

    def find(coord_x)
      @aliens
        .select { |alien| alien.area?(coord_x) }
        .max_by(&:y)
    end

    def destroy(coord_x, coord_y)
      killed = @aliens.find { |alien| alien.x == coord_x && alien.y == coord_y }
      return unless killed

      @aliens.delete(killed)
      @last_killed = killed.type
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
      directions = available_directions
      return if directions.values.all?(&:!)

      @move_direction = if @move_direction == :bottom
                          directions.key(true)
                        else
                          :bottom
                        end
    end

    def available_directions
      max_x_alien = @aliens.max_by(&:x).x
      min_x_alien = @aliens.min_by(&:x).x
      alien_width = Settings::ALIENS_WIDTH
      {
        right: min_x_alien < @move_step,
        left: max_x_alien > Settings::WIDTH - alien_width - @move_step
      }
    end
  end
end
