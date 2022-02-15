# frozen_string_literal: true

require 'gosu'
require_relative '../base/menu_scene_component'
require_relative '../base/text_field'
require_relative 'menu'
require_relative '../db/operations'

module SpaceInvaders
  class NewGame < MenuSceneComponent
    attr_reader :need_start

    def initialize(window, size)
      super

      @input = TextField.new(window, @font)
      @input.text = 'Type new game name'
      @input.restrict = /[^a-z]/i

      @menu = Menu.new(window, size)
      @menu.add_item('Continue', callback: method(:start_game))
      @menu.reset_selection
      @need_start = false
    end

    def draw(x, y)
      @input.draw(x, y)
      left_margin = Settings::VERTICAL_MARGIN_FOR_ITEM * 6
      @menu.draw(x + left_margin, y + @font_size + Settings::VERTICAL_MARGIN_FOR_ITEM)
    end

    def button_down(id)
      @input.button_down(id)
      if @input.text.empty?
        @menu.reset_selection
      else
        @menu.run_selection
        @menu.run_command if id == Gosu::KbReturn
      end
    end

    def start_game
      DBOperations.reset_previous_session
      DBOperations.insert(score: 0, user: @input.text, active: true)
      @need_start = true
    end
  end
end
