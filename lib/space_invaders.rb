# frozen_string_literal: true

require 'gosu'
require_relative 'space_invaders/settings/settings'
require_relative 'space_invaders/ship'
require_relative 'space_invaders/aliens_pack'

module SpaceInvaders
  class Game < Gosu::Window
    def initialize(width = ScreenSettings::WIDTH,
                   height = ScreenSettings::HEIGHT)
      super
      self.caption = ScreenSettings::CAPTION
      @screen_width = width
      @screen_height = height

      @draws = 0
      @ship = Ship.new
      @aliens = []
      @game_objects = [@ship]

      setup_bg
      setup_assets
    end

    def update
      @ship.move_left! if button_down?(Gosu::KbLeft)
      @ship.move_right! if button_down?(Gosu::KbRight)
    end

    def button_down(id)
      close if id == Gosu::KbEscape
    end

    def draw
      @draws += 1
      @bg.draw(0, 0, 0)
      @ship.draw
      @aliens.each(&:draw)
    end

    def needs_redraw?
      @draws == 0 || @game_objects.any?(&:needs_redraw?)
    end

    private

    def setup_bg
      bg_image = AssetsSettings::IMAGES_PATH / 'space.png'
      @bg = Gosu::Image.new(bg_image.to_s)
    end

    def setup_assets
      setup_ship
      setup_aliens
    end

    def setup_ship
      @ship.set(
        @screen_width / 2 - @ship.w / 2,
        @screen_height * 0.9 - @ship.h / 2,
        [0, @screen_width]
      )
    end

    def setup_aliens
      alien_y = margin = AliensSettings::MARGIN
      aliens_pack = DefaultAliensPack.new
      AliensSettings::ROWS.times do
        alien_x = @screen_width * 0.05

        AliensSettings::PER_ROW.times do
          alien_path = aliens_pack.next_alien
          alien = Alien.new(alien_x, alien_y, alien_path)
          alien_x += alien.w + margin
          @aliens << alien
        end

        alien_y += AliensSettings::HEIGHT + margin
      end
    end
  end
end

game = SpaceInvaders::Game.new
game.show
