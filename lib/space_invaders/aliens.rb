# frozen_string_literal: true

require 'gosu'
require_relative 'base/settings'
require_relative 'game_objects/alien'

module SpaceInvaders
  class Aliens
    INVASION_SOUND = Settings::SOUNDS_PATH / 'invasion.mp3'
    DELAY_DRAW_MSEC = 700

    def initialize(place_x, place_y)
      @aliens = []
      @place_x = place_x
      @place_y = place_y

      @invasion_sound = Gosu::Sample.new(INVASION_SOUND)

      @move_direction = :right
      @move_step = Settings::ALIENS_MARGIN
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
      @aliens.reject!(&:destroys?)
      @aliens.each(&:draw)
      move if can_move?
    end

    def needs_redraw?
      @aliens.any?(&:needs_redraw?)
    end

    def find(coord_x)
      @aliens.select { |alien| alien.area?(coord_x, alien.y) }
             .max_by(&:y)
    end

    def last_killed
      @aliens.find(&:destroys?)&.type
    end

    def shoot(enemy)
      closest_alien_to(enemy).shoot(enemy)
    end

    private

    def move
      @aliens.each do |alien|
        move_x, move_y = next_move_coords_for(alien.x, alien.y)
        alien.set(move_x, move_y)
        alien.on_move
      end

      @invasion_sound.play
      next_move_direction
    end

    def can_move?
      unless @last_move_time
        @last_move_time = Gosu.milliseconds
        return true
      end

      moving = Gosu.milliseconds - @last_move_time > DELAY_DRAW_MSEC
      @last_move_time = Gosu.milliseconds if moving
      moving
    end

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
      alien_width = Settings::ALIENS_WIDTH
      {
        right: first_column_x < @move_step,
        left: last_column_x > Settings::WIDTH - alien_width - @move_step
      }
    end

    def last_column_x
      @aliens.max_by(&:x).x
    end

    def first_column_x
      @aliens.min_by(&:x).x
    end

    def closest_alien_to(target)
      closest = find(target.x)
      return closest if closest

      return find(last_column_x) if last_column_x < target.x

      find(first_column_x) if first_column_x > target.x
    end
  end
end
