class Player
  def initialize(x, y)
    @image = Gosu::Image.new("media/starfighter.bmp")
    @x = x
    @y = y
    @angle = 0.0
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end
