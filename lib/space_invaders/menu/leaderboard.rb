# frozen_string_literal: true

require 'gosu'
require_relative '../db/operations'
require_relative '../base/menu_scene_component'

module SpaceInvaders
  class Leaderboard < MenuSceneComponent
    def initialize(window, font_size)
      super

      @leaders = DBOperations.find_max_scores(5)
    end

    def visible?
      @leaders.any?
    end

    def draw(x, y)
      @leaders.each do |leader|
        coord_x = x + leader_offset_x(leader)
        @font.draw(leader_record(leader), coord_x, y, 0)
        y += @font_size + Settings::VERTICAL_MARGIN_FOR_ITEM
      end

      @was_draw = true
    end

    def leader_offset_x(leader)
      first_item_text_len = leader_record(@leaders.first).size
      (first_item_text_len - leader_record(leader).size) * @font_size / Settings::CHAR_OFFSET_RATIO
    end

    def leader_record(leader)
      "#{leader[:user]} - #{leader[:score]} POINTS"
    end
  end
end
