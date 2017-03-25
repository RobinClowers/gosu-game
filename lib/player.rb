require 'gosu'
require 'rmagick'
require_relative 'game_window'
require_relative 'z_index'
require_relative 'animation'

class Player
  include Gosu

  attr_reader :score

  MoveSpeed = 3

  def initialize(x, y)
    @characters = Image.load_tiles("media/spaceship.png", 15, 24)
    @idle = @characters[0]
    @moving = @characters[1]
    @character = @idle
    @attack = false
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
    @accelerating = true
    @character = @moving
    @x_velocity += offset_x(@angle, 0.5)
    @y_velocity += offset_y(@angle, 0.5)
  end

  def stop
    @character = @idle
  end

  def move
    @x += @x_velocity
    @y += @y_velocity
    @x %= GameWindow::Height
    @y %= GameWindow::Width
    @x_velocity *= 0.98
    @y_velocity *= 0.98
  end

  def attack
    @attack = true
  end

  def draw
    @character.draw_rot(@x, @y, ZIndex::Player, @angle)
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
