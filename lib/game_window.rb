require 'gosu'
require_relative 'player'
require_relative 'star'
require_relative 'tiler'
require_relative 'z_index'

class GameWindow < Gosu::Window
  include Gosu

  Height = 640
  Width = 480

  def initialize
    super Height, Width
    self.caption = "Gosu Tutorial Game"

    @player = Player.new(Height / 2, Width / 2)
    @background_image = Image.new("media/grass.png", tileable: true)
    @tiler = Tiler.new(@background_image)
    @star_animation = Image.load_tiles("media/star.png", 25, 25)
    @stars = []
    @font = Font.new(20)
  end

  def update
    @player.left if button_down? KbLeft
    @player.right if button_down? KbRight
    @player.up if button_down? KbUp
    @player.down if button_down? KbDown
    @player.move
    @stars = @player.collect_stars(@stars)

    if rand(100) < 4 && @stars.length < 25
      @stars << Star.new(@star_animation)
    end
  end

  def button_up(id)
    if [KbDown,
        KbUp,
        KbRight,
        KbLeft,
      ].include? id
      @player.stop
    end
  end

  def draw
    @tiler.draw
    @player.draw
    @stars.each(&:draw)
    @font.draw("Score: #{@player.score}", 10, 10, ZIndex::UI, 1.0, 1.0, 0xff_ffff00)
  end
end
