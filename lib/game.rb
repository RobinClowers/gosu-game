require 'gosu'
require_relative 'player'
require_relative 'z_index'

class GameWindow < Gosu::Window
  include Gosu

  def initialize
    super 640, 480
    self.caption = "Gosu Tutorial Game"

    @background_image = Image.new("media/space.png", tileable: true)
    @player = Player.new(320, 240)
  end

  def update
    @player.turn_left if button_down? KbLeft
    @player.turn_right if button_down? KbRight
    @player.accelerate if button_down? KbUp
    @player.move
  end

  def draw
    @background_image.draw(0, 0, ZIndex::Background)
    @player.draw
  end
end

window = GameWindow.new
window.show
