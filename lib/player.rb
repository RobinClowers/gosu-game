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
    @character_walking = Animation.new(
      "media/character_walking.png",
      width: 32,
      height: 41,
      length: 13,
      frame_rate: 10,
      rows: 3,
      columns: 13,
    ) do |rows|
      {
        down: rows[0],
        left: rows[1].clone.map { |image| flop_image(image) },
        right: rows[1],
        up: rows[2],
      }
    end
    @attack_down = Animation.new(
      "media/attack_down.png",
      width: 38,
      height: 48,
      length: 8
    ) do |rows|
      {
        down: rows[0],
        left: rows[0].clone.map { |image| rotate_image(image, 90) },
        right: rows[0].clone.map { |image| rotate_image(image, 270) },
        up: rows[0].clone.map { |image| rotate_image(image, 180) },
      }
    end
    @attack = false
    @beep = Sample.new("media/beep.wav")
    @x = x
    @y = y
    @score = 0
    @animation_index = 0
    @frames_since_update = 0
    @direction = :down
    @stopped = :true
  end

  def left
    @stopped = false
    @direction = :left
  end

  def right
    @stopped = false
    @direction = :right
  end

  def up
    @stopped = false
    @direction = :up
  end

  def down
    @stopped = false
    @direction = :down
  end

  def move
    return if @stopped
    case @direction
      when :up
        @y -= MoveSpeed
      when :right
        @x += MoveSpeed
      when :down
        @y += MoveSpeed
      when :left
        @x -= MoveSpeed
    end
    @x %= GameWindow::Height
    @y %= GameWindow::Width
  end

  def attack
    @attack = true
  end

  def stop
    @stopped = true
  end

  def draw
    if @attack
      @attack_down.draw(@direction, @x, @y)
      @attack = @attack_down.in_progress?
    else
      @character_walking.draw(@direction, @x, @y, animate: !@stopped)
    end
  end

  def collect_stars(stars)
    remaining = stars.reject { |star| distance(@x, @y, star.x, star.y) < 35 }
    (stars.count - remaining.count).times do
      @beep.play
      @score += 1
    end
    remaining
  end

  def flop_image(image)
    Image.new(rmagick_image(image).flop!)
  end

  def rotate_image(image, degrees)
    Image.new(rmagick_image(image).rotate!(degrees))
  end

  def rmagick_image(image)
    Magick::Image.from_blob(image.to_blob) {
      self.format = "RGBA"
      self.depth = 8
      self.size = "#{image.width}x#{image.height}"
    }.first
  end
end
