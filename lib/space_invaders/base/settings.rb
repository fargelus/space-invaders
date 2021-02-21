# frozen_string_literal: true

require 'pathname'
require 'gosu'

module SpaceInvaders
  module Settings
    WIDTH = 800
    HEIGHT = 600
    CAPTION = 'Space Invaders'
    VERSION = '0.1.0'
    SPACESHIP_SPEED = 3
    SPACESHIP_LIFES = 3
    BULLET_SPEED = 5
    BULLET_DIRECTION_UP = -1
    BULLET_DIRECTION_DOWN = 1
    ALIENS_ROWS = 5
    ALIENS_PER_ROW = 10
    ALIENS_MARGIN = 15
    LIFES_MARGIN = 5
    ALIENS_HEIGHT = 32
    ALIENS_WIDTH = 48
    BULLET_WIDTH = 6
    BULLET_HEIGHT = 17
    ASSETS_DIR = Pathname.new(__dir__).join('../../') / 'assets'
    IMAGES_PATH = ASSETS_DIR / 'images'
    BULLETS_DIR = IMAGES_PATH / 'bullets'
    SOUNDS_PATH = ASSETS_DIR / 'sounds'
    FONT = ASSETS_DIR / 'fonts/default.ttf'
    INFO_FONT_SIZE = 40
    LABEL_FONT_SIZE = 18
    CAPTION_FONT_SIZE = 55
    SOUNDS_VOLUME = 8
    ALIENS_DIR = IMAGES_PATH / 'invaders'
    ALIENS_PATH_TO_TYPE = {
      Pathname.new(ALIENS_DIR / 'spider.png') => :spider,
      Pathname.new(ALIENS_DIR / 'robot.png') => :robot,
      Pathname.new(ALIENS_DIR / 'skull.png') => :skull,
      Pathname.new(ALIENS_DIR / 'predator.png') => :predator,
      Pathname.new(ALIENS_DIR / 'mistery.png') => :mistery
    }.freeze
    TILEABLE_ALIENS_PATH_TO_TYPE = {
      Pathname.new(ALIENS_DIR / 'tiles/spider_tiles.png') => :spider,
      Pathname.new(ALIENS_DIR / 'tiles/robot_tiles.png') => :robot,
      Pathname.new(ALIENS_DIR / 'tiles/skull_tiles.png') => :skull,
      Pathname.new(ALIENS_DIR / 'tiles/predator_tiles.png') => :predator
    }.freeze
    TILEABLE_ALIENS_PATHS = TILEABLE_ALIENS_PATH_TO_TYPE.keys
    RENDER_TILEABLE_ALIENS = TILEABLE_ALIENS_PATHS + [TILEABLE_ALIENS_PATHS[-1]]
    ALIENS_SCOREBOARD = {
      predator: 10,
      robot: 20,
      skull: 30,
      spider: 50
    }.freeze
    MISTERY_SCORES = [50, 100, 150].freeze
    MISTERY_WIDTH = 57
    RED_COLOR = Gosu::Color.new(214, 17, 17)
    GREEN_COLOR = Gosu::Color.new(9, 222, 1)
    SUNNY_COLOR = Gosu::Color.new(217, 240, 8)
    BROWN_COLOR = Gosu::Color.new(133, 104, 66)
    EFFECTS_DIR = IMAGES_PATH / 'effects'

    def ship_ammo_options
      {
        shot_sound_path: SOUNDS_PATH / 'spaceship_gun.wav',
        bullet_image_path: BULLETS_DIR / 'bullet.png',
        direction: BULLET_DIRECTION_UP
      }
    end

    def alien_ammo_options(type)
      {
        shot_sound_path: Settings::SOUNDS_PATH / 'alien_gun.wav',
        bullet_image_path: Settings::BULLETS_DIR / "#{type}_bullet.png",
        direction: Settings::BULLET_DIRECTION_DOWN
      }
    end
  end
end
