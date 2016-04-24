require_relative 'game_window'

class Tiler
  def initialize(image)
    @image = image
  end

  def draw
    tiles.each do |x, y|
      @image.draw(x, y, ZIndex::Background)
    end
  end

  def tiles
    @tiles ||= generate_tiles
  end

  def generate_tiles
    x_tile_count.times.map do |x|
      y_tile_count.times.map do |y|
        [@image.height * y, @image.width * x]
      end
    end.flatten(1)
  end

  def x_tile_count
    @x_tile_count ||= (GameWindow::Width / @image.width) + 1
  end

  def y_tile_count
    @y_tile_count ||= (GameWindow::Height / @image.height) + 1
  end
end
