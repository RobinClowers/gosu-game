require_relative 'game_window'

class Tiler
  def initialize(*images)
    @images = images
  end

  def draw
    tiles.each do |image, x, y|
      image.draw(x, y, ZIndex::Background)
    end
  end

  def tiles
    @tiles ||= generate_tiles
  end

  def generate_tiles
    x_tile_count.times.map do |x|
      y_tile_count.times.map do |y|
        [@images.sample, height * y, width * x]
      end
    end.flatten(1)
  end

  def random_image
    @images.sample
  end

  def height
    @images.first.height
  end

  def width
    @images.first.width
  end

  def x_tile_count
    @x_tile_count ||= (GameWindow::Width / width) + 1
  end

  def y_tile_count
    @y_tile_count ||= (GameWindow::Height / height) + 1
  end
end
