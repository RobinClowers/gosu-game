require 'gosu'
require './lib/player'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @player = Player.new(320, 240)
  end

  def update
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
  end
end

window = GameWindow.new
window.show
