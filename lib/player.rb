require 'gosu'
require_relative 'z_index'

class Player
  include Gosu

  attr_reader :score

  def initialize(x, y)
    @image = Image.new("media/starfighter.bmp")
    @beep = Sample.new("media/beep.wav")
    @x = x
    @y = y
    @x_velocity = @y_velocity = @angle = 0.0
    @score = 0
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @x_velocity += offset_x(@angle, 0.5)
    @y_velocity += offset_y(@angle, 0.5)
  end

  def move
    @x += @x_velocity
    @y += @y_velocity
    @x %= 640
    @y %= 480

    @x_velocity *= 0.98
    @y_velocity *= 0.98
  end

  def draw
    @image.draw_rot(@x, @y, ZIndex::Player, @angle)
  end

  def collect_stars(stars)
    remaining = stars.reject { |star| distance(@x, @y, star.x, star.y) < 35 }
    (stars.count - remaining.count).times do
      @beep.play
      @score += 1
    end
    remaining
  end
end
