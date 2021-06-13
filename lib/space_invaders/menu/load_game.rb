# frozen_string_literal: true

require 'gosu'
require_relative '../base/menu_scene_component'
require_relative '../db/operations'
require_relative 'menu'

module SpaceInvaders
  class LoadGame < MenuSceneComponent
    def initialize(window, font_size)
      super

      @games = DBOperations.all_records
      @window = window
      @menu = Menu.new(window, font_size)
      @games.each { |game| @menu.add_item(game[:user], callback: method(:test)) }
    end

    def draw(x, y)
      @menu.draw(x, y)
      @was_draw = true
    end

    def button_down(id)
      @was_draw = false
      @menu.button_down(id)
    end

    private

    def test
      puts 'TEEEEESSSSTTTTT'
    end

    def game_offset_x(game)
      users = @games.collect { |game| game[:user] }
      first_item_text_len = users.first.size
      (first_item_text_len - game[:user].size) * @font_size / Settings::CHAR_OFFSET_RATIO
    end
  end
end
