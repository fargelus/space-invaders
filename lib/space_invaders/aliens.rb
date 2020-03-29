# frozen_string_literal: true

require_relative 'settings'
require_relative 'alien'

module SpaceInvaders
  class Aliens
    def initialize(edge_x)
      @aliens = []
      @edge_x = edge_x
    end

    def setup
      alien_y = margin = Settings::ALIENS_MARGIN
      Settings::ALIENS_ROWS.times do
        place_aliens_in_row(alien_y)
        alien_y += Settings::ALIENS_HEIGHT + margin
      end
    end

    def place_aliens_in_row(alien_y)
      alien_x = @edge_x
      all_aliens = Settings::ALL_ALIENS.cycle
      Settings::ALIENS_PER_ROW.times do
        alien = Alien.new(alien_x, alien_y, all_aliens.next)
        alien_x += alien.w + Settings::ALIENS_MARGIN
        @aliens << alien
      end
    end

    def draw
      @aliens.each(&:draw)
    end

    def find(x)
      @aliens
        .select { |alien| alien.area?(x) }
        .max_by(&:y)
    end

    def destroy(x, y)
      @aliens.reject! { |alien| alien.x == x && alien.y == y }
    end
  end
end
