# frozen_string_literal: true

require 'gosu'
require_relative '../base/settings'
require_relative '../db/operations'

module SpaceInvaders
  class Score
    def initialize(options)
      @x = options[:x] || 0
      @y = options[:y] || 0
      @font_size = 25
      @score_obj = Gosu::Font.new(
        options[:window],
        Settings::FONT,
        @font_size
      )
      @score_text = ''
      @score = 0
    end

    def draw(*); end

    def up(alien_type)
      return unless alien_type

      up_score = if alien_type == :mistery
                   Settings::MISTERY_SCORES.sample
                 else
                   Settings::ALIENS_SCOREBOARD[alien_type]
                 end
      @score += up_score
    end
  end
end
