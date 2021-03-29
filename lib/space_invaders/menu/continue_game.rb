# frozen_string_literal: true

require 'gosu'
require_relative '../base/menu_scene_component'
require_relative '../db/operations'

module SpaceInvaders
  class ContinueGame < MenuSceneComponent
    def initialize(window, size)
      super
    end

    def visible?
      DBOperations.current_user
    end
  end
end
