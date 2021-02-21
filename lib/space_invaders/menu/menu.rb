# frozen_string_literal: true

require 'gosu'
require_relative 'menu_item'

module SpaceInvaders
  class Menu
    def initialize(window)
      @window = window
      @items = []
    end

    def add_item(options)
      @items << MenuItem.new(@window, options)
    end

    def needs_redraw?
      @items.any?(&:needs_redraw?)
    end

    def draw
      @items.each(&:draw)
    end
  end
end
