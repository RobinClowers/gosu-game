require 'gosu'
require 'rmagick'
require_relative 'game_window'
require_relative 'z_index'
require_relative 'sprite_sheet'
require_relative 'animation'

class Player
  include Gosu

  TurnSpeed = 4.5

  attr_reader :score

  def initialize(x, y)
    @ship = SpriteSheet.new(
      "media/spaceship.png",
      width: 15,
      height: 24,
      rows: 1,
      columns: 2,
    ) do |rows|
      frames = rows[0].map { |image| Image.new(image.to_rmagick.scale!(2)) }
      {
        stopped: Animation.new(frames[0]),
        moving: Animation.new(frames, frame_interval: 10),
      }
    end
    @ship_state = :stopped
    @attack = false
    @beep = Sample.new("media/beep.wav")
    @x = @waypoint_x = x
    @y = @waypoint_y = y
    @x_velocity = @y_velocity = @angle = 0.0
    @score = 0
  end

  def waypoint(x, y)
    @waypoint_x = x
    @waypoint_y = y
    target_angle = angle(@x, @y, @waypoint_x, @waypoint_y)
    diff = angle_diff(@angle, target_angle)
    if diff.positive?
      if diff.abs > TurnSpeed
        turn_right
      else
        @angle = target_angle
      end
    else
      if diff.abs > TurnSpeed
        turn_left
      else
        @angle = target_angle
      end
    end
    accelerate
  end

  def turn_left
    @angle -= TurnSpeed
  end

  def turn_right
    @angle += TurnSpeed
  end

  def accelerate
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
