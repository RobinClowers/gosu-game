require 'gosu'
require_relative 'game_window'
require_relative 'z_index'

class Player
  include Gosu

  attr_reader :score

  MoveSpeed = 3
  TurnRate = 4.5
  SpriteDirectionMap = {
    up: 3,
    right: 2,
    down: 0,
    left: 1,
  }

  def initialize(x, y)
    @characters = Image.load_tiles("media/characters.png", 32, 48)
    @character = extract_character
    @current_character = @character[0]
    @beep = Sample.new("media/beep.wav")
    @x = x
    @y = y
    @score = 0
    @direction = :stopped
  end

  def left
    @direction = :left
  end

  def right
    @direction = :right
  end

  def up
    @direction = :up
  end

  def down
    @direction = :down
  end

  def move
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

  def stop
    @direction = :stopped
  end

  def draw
    unless @direction == :stopped
      row = SpriteDirectionMap[@direction]
      @current_character = @character[row * 3]
    end
    @current_character.draw_rot(@x, @y, ZIndex::Player, 0.0)
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
