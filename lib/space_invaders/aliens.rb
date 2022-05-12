# frozen_string_literal: true

require 'gosu'
require 'forwardable'
require_relative 'base/settings'
require_relative 'base/helpers'
require_relative 'base/timer'
require_relative 'game_objects/image_objects/animated_alien'
require_relative 'game_objects/image_objects/mistery_alien'

module SpaceInvaders
  class Aliens
    include Helpers
    include Settings
    extend Forwardable

    INVASION_SOUND = SOUNDS_PATH / 'invasion.mp3'
    DELAY_DRAW_MSEC = 700
    DELAY_SHOOT_MSEC = 1500
    MISTERY_DRAW_DELAY_MSEC = 30_000

    attr_reader :last_killed

    def_delegator :@aliens, :each, :each

    def initialize(coord_x:, coord_y:, enemy:)
      @aliens = []
      @place_x = coord_x
      @place_y = coord_y
      @enemy = enemy

      @invasion_sound = Gosu::Sample.new(INVASION_SOUND)

      @move_direction = :right
    end

    def setup
      alien_y = @place_y
      @last_move_time = nil
      ALIENS_ROWS.times do |i|
        place_aliens_in_row(i, alien_y)
        alien_y += ALIENS_HEIGHT + ALIENS_MARGIN
      end
      @mistery = MisteryAlien.new(@place_y)
    end

    def place_aliens_in_row(index, alien_y)
      alien_x = @place_x
      alien_path = RENDER_TILEABLE_ALIENS[index]
      ALIENS_PER_ROW.times do
        alien = AnimatedAlien.new(alien_x, alien_y, alien_path)
        alien_x += alien.w + ALIENS_MARGIN
        @aliens << alien
      end
    end

    def draw
      @last_killed = @aliens.find(&:destroyed?)&.type
      @aliens.reject!(&:destroyed?)
      @aliens.each(&:draw)
      move if can_move?
      @mistery.draw if mistery_appears?
    end

    def needs_redraw?
      @aliens.any?(&:needs_redraw?)
    end

    def find(coord_x)
      @aliens.select { |alien| alien.area?(coord_x, alien.y) }
             .max_by(&:y)
    end

    def first_row_y
      @aliens.max_by(&:y)&.y
    end

    def destroyed?
      @aliens.empty?
    end

    def need_shoot?
      @last_shoot_time ||= Gosu.milliseconds
      @aliens.any? && Gosu.milliseconds - @last_shoot_time > DELAY_SHOOT_MSEC
    end

    def shoot(obstacle:)
      above_enemy_alien.shoot(@enemy, obstacle)
      @last_shoot_time = Gosu.milliseconds
    end

    private

    def move
      @aliens.each do |alien|
        move_x, move_y = next_move_coords_for(alien.x, alien.y)
        alien.move(move_x, move_y)
      end

      @invasion_sound.play if @mistery.on_start
      next_move_direction
      @last_move_time = Gosu.milliseconds
    end

    def above_enemy_alien
      closest = find(@enemy.x)
      return closest if closest

      closest = find(@enemy.x + @enemy.w)
      return closest if closest

      further_x = max_x_coord(@aliens)
      return find(further_x) if further_x < @enemy.x

      find(min_x_coord(@aliens))
    end

    def can_move?
      return true unless @last_move_time

      Gosu.milliseconds - @last_move_time > DELAY_DRAW_MSEC
    end

    def next_move_coords_for(alien_x, alien_y)
      case @move_direction
      when :right
        [alien_x + ALIENS_MARGIN, alien_y]
      when :left
        [alien_x - ALIENS_MARGIN, alien_y]
      when :bottom
        [alien_x, alien_y + ALIENS_MARGIN]
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
      extreme_right_aliens = WIDTH - ALIENS_WIDTH - ALIENS_MARGIN
      {
        right: min_x_coord(@aliens) < ALIENS_MARGIN,
        left: max_x_coord(@aliens) > extreme_right_aliens
      }
    end

    def mistery_appears?
      return true unless @mistery.on_start

      Timer.overtime?(MISTERY_DRAW_DELAY_MSEC)
    end
  end
end
