require 'gosu'
require_relative 'player'
require_relative 'star'
require_relative 'z_index'

class GameWindow < Gosu::Window
  include Gosu

  Height = 640
  Width = 480

  def initialize
    super Height, Width
    self.caption = "Gosu Tutorial Game"

    @background_image = Image.new("media/space.png", tileable: true)
    @player = Player.new(Height / 2, Width / 2)
    @star_animation = Image.load_tiles("media/star.png", 25, 25)
    @stars = []
  end

  def update
    @player.turn_left if button_down? KbLeft
    @player.turn_right if button_down? KbRight
    @player.accelerate if button_down? KbUp
    @player.move

    if rand(100) < 4 && @stars.length < 25
      @stars << Star.new(@star_animation)
    end
  end

  def draw
    @background_image.draw(0, 0, ZIndex::Background)
    @player.draw
    @stars.each(&:draw)
  end
end

window = GameWindow.new
window.show
