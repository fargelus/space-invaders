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

    def draw(x, y)
      top_margin = 10
      @leaders.each do |leader|
        next unless leader[:user]

        record = "#{leader[:user]}#{('.' * 20)}#{leader[:score]}"
        @font.draw(record, x, y, 0)
        y += @font_size + top_margin
      end
    end
  end
end
