require 'gosu'
require_relative 'gosu_image_refinements'
require_relative 'player'
require_relative 'star'
require_relative 'tiler'
require_relative 'z_index'
require_relative 'mouse_handler'

class GameWindow < Gosu::Window
  include Gosu
  include MouseHandler

  Height = 640
  Width = 480

  def initialize
    super Height, Width
    self.caption = "Awesome Gosu Game!"

    @player = Player.new(Height / 2, Width / 2)
    @grass = Image.new("media/grass.png", tileable: true)
    @idle = Image.new(@grass.to_rmagick.scale!(2))
    @tiler = Tiler.new(@grass)
    @star_animation = Image.load_tiles("media/star.png", 25, 25)
    @stars = []
    @font = Font.new(20)
  end

  def update
    @player.stop
    @player.turn_left if button_down? KbLeft
    @player.turn_right if button_down? KbRight
    @player.accelerate if button_down? KbUp
    @player.move
    @stars = @player.collect_stars(@stars)

    if rand(100) < 4 && @stars.length < 25
      @stars << Star.new(@star_animation)
    end
  end

  def draw
    @tiler.draw
    @player.draw
    @stars.each(&:draw)
    @font.draw("Score: #{@player.score}", 10, 10, ZIndex::UI, 1.0, 1.0, 0xff_ffff00)
  end
end
