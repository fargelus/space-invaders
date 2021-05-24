# frozen_string_literal: true

require 'gosu'
require_relative '../base/menu_scene_component'
require_relative '../db/operations'

module SpaceInvaders
  class LoadGame < MenuSceneComponent
    def initialize(window, font_size)
      super

      @games = DBOperations.all_records
    end

    def draw(x, y)
      @games.each do |game|
        coord_x = x + game_offset_x(game)
        @font.draw(game[:user], coord_x, y, 0)
        y += Settings::VERTICAL_MARGIN_FOR_ITEM / 2 + @font_size
      end

      @was_draw = true
    end

    private

    def game_offset_x(game)
      users = @games.collect { |game| game[:user] }
      first_item_text_len = users.first.size
      (first_item_text_len - game[:user].size) * @font_size / Settings::CHAR_OFFSET_RATIO
    end
  end
end
