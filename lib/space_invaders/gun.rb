require_relative 'settings'
require_relative 'bullet'

module SpaceInvaders
  class Gun < GameObject
    def initialize
      @ammo = { Bullet.new => nil }
      @reload_time_msec = 100
      @prev_shoot_timestamp = Gosu.milliseconds
    end

    def needs_redraw?
      @ammo.keys.any?(&:needs_redraw?)
    end

    def draw
      @ammo.each_pair do |bullet, target|
        if bullet.moves? && target < bullet.y
          bullet.draw
        end
      end
    end

    def shoot!(target)
      @prev_shoot_timestamp ||= Gosu.milliseconds
      if ready_for_shoot?
        @prev_shoot_timestamp = nil
        bullet = Bullet.new(@x, @y)
        bullet.moving = true
        @ammo[bullet] = target
      end
    end

    def w
      @ammo.keys[0].w
    end

    private

    def ready_for_shoot?
      Gosu.milliseconds - @prev_shoot_timestamp > @reload_time_msec
    end
  end
end
