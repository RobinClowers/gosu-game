require 'gosu'
require_relative 'player'
require_relative 'z_index'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new("media/space.png", tileable: true)
    @player = Player.new(320, 240)
  end

  def update
    @player.turn_left if Gosu.button_down? Gosu::KbLeft
    @player.turn_right if Gosu.button_down? Gosu::KbRight
    @player.accelerate if Gosu.button_down? Gosu::KbUp
    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZIndex::Background)
    @player.draw
  end
end

window = GameWindow.new
window.show
