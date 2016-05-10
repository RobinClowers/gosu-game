require 'gosu'
require 'rmagick'
require_relative 'game_window'
require_relative 'z_index'

class Player
  include Gosu

  attr_reader :score

  MoveSpeed = 3
  CharacterRowCount = 3
  SpriteColumnCount = 13
  SpriteDirectionMap = {
    down: 0,
    right: 2,
    left: 1,
    up: 3,
  }

  def initialize(x, y)
    @character = Image.load_tiles("media/character_walking.png", 32, 41)
    @walking_animation = extract_character
    @current_character = @walking_animation[:down][0]
    @beep = Sample.new("media/beep.wav")
    @x = x
    @y = y
    @score = 0
    @animation_index = 0
    @frames_since_update = 0
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
      @current_character = @walking_animation[@direction][@animation_index]
      update_frame_index
    end
    @current_character.draw_rot(@x, @y, ZIndex::Player, 0.0)
  end

  def draw_all
    row_index = 0
    character_rows.each do |row|
      row.each_with_index do |frame, index|
        frame.draw_rot(@x + index * frame.width, @y + frame.height * row_index, ZIndex::Player, 0.0)
      end
      row_index += 1
    end
  end

  def update_frame_index
    return @frames_since_update += 1 unless @frames_since_update > 9

    @frames_since_update = 0
    if @animation_index < SpriteColumnCount - 1
      @animation_index += 1
    else
      @animation_index = 0
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

  def extract_character
    {
      down: character_rows[0],
      left: character_rows[1].clone.map { |image|
        flop_image(image)
      },
      right: character_rows[1],
      up: character_rows[2],
    }
  end

  def character_rows
    @character_rows ||= CharacterRowCount.times.map { |row|
      extract_animation(y_offset: row)
    }
  end

  def extract_animation(y_offset: 0, columns: SpriteColumnCount)
    offset = y_offset * columns
    @character[offset..offset + columns - 1]
  end

  def flop_image(image)
    Image.new(
      Magick::Image.from_blob(image.to_blob) {
        self.format = "RGBA"
        self.depth = 8
        self.size = "#{image.width}x#{image.height}"
      }.first.flop!
    )
  end
end
