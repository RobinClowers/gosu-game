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
    @ship = Animation.new(
      "media/spaceship.png",
      width: 15,
      height: 24,
      length: 2,
      frame_rate: 10,
      rows: 1,
      columns: 2,
    ) do |rows|
    @characters = Image.load_tiles("media/spaceship.png", 15, 24)
      frames = rows[0].map { |image| Image.new(image.to_rmagick.scale!(2)) }
      {
        stopped: [frames[0], frames[0]],
        moving: frames,
      }
    end
    @ship_state = :stopped
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
    @ship_state = :moving
    @x_velocity += offset_x(@angle, 0.5)
    @y_velocity += offset_y(@angle, 0.5)
  end

  def stop
    @ship_state = :stopped
  end

  def move
    @x += @x_velocity
    @y += @y_velocity
    @x %= GameWindow::Height
    @y %= GameWindow::Width
    @x_velocity *= 0.95
    @y_velocity *= 0.95
  end

  def attack
    @attack = true
  end

  def draw
    @ship.draw(@ship_state, @x, @y, angle: @angle)
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
