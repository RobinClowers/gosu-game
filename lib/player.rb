require 'gosu'
require_relative 'game_window'
require_relative 'z_index'

class Player
  include Gosu

  attr_reader :score

  def initialize(x, y)
    @characters = Image.load_tiles("media/characters.png", 32, 48)
    @character = extract_character
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
    @x %= GameWindow::Height
    @y %= GameWindow::Width

    @x_velocity *= 0.98
    @y_velocity *= 0.98
  end

  def draw
    @character[0].draw_rot(@x, @y, ZIndex::Player, @angle)
  end

  def collect_stars(stars)
    remaining = stars.reject { |star| distance(@x, @y, star.x, star.y) < 35 }
    (stars.count - remaining.count).times do
      @beep.play
      @score += 1
    end
    remaining
  end

  def extract_character(character_index: 3)
    characters_per_row = 4
    start_index = character_index * characters_per_row
    4.times.map do |row|
      i = start_index * row
      @characters[i..i + 2]
    end.flatten(1)
  end
end
