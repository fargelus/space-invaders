# frozen_string_literal: true

require 'gosu'
require_relative 'settings'

module SpaceInvaders
  class TextField < Gosu::TextInput
    include Settings
    attr_accessor :restrict

    def initialize(window)
      super()

      @window = window
      @printed = false
    end

    def filter?(text)
      text =~ @restrict
    end

    def button_down(id)
      input = @window.button_id_to_char(id)

      return if restrict && filter?(input)

      self.text = '' unless @printed
      @printed = true
      return insert_text(input) unless id == Gosu::KbBackspace

      self.text = self.text[0..-2]
    end
  end
end
