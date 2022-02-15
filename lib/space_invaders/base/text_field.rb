# frozen_string_literal: true

require 'gosu'
require_relative 'settings'
require_relative 'text_caret'

module SpaceInvaders
  class TextField < Gosu::TextInput
    include Settings
    attr_accessor :restrict

    def initialize(window, font)
      super()

      @window = window
      @font = font
      @printed = false
      @caret = TextCaret.new(@window)
    end

    def filter?(text)
      text =~ @restrict
    end

    def draw(x, y)
      @font.draw(text, x, y, 0)
      @caret.draw(x: x, y: y,
                  text_height: @font.height,
                  text_width: @font.text_width(text[0...caret_pos]))
    end

    def button_down(id)
      input = @window.button_id_to_char(id)

      return if restrict && filter?(input)

      self.text = '' unless @printed
      @printed = true
      return insert_text(input) unless id == Gosu::KbBackspace

      self.text = text[0..-2]
    end
  end
end
