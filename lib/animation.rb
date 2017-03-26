class Animation
  include Gosu

  def initialize(animation, frame_interval: 2)
    @animation = Array(animation)
    @frame_interval = frame_interval
    @frames_since_update = 0
    @index = 0
  end

  def draw(x, y, z_index: ZIndex::Player, animate: true, angle: 0)
    @frame = @animation[@index]
    @frame.draw_rot(x, y, z_index, angle)
    return false unless animate
    update_index
    @index != 0
  end

  def in_progress?
    @index != 0
  end

  def draw_row(x, y)
    @animation.each_with_index do |frame, index|
      frame.draw_rot(x + index * frame.width, y + frame.height * row_index, ZIndex::Player, 0.0)
    end
  end

  def update_index
    return @frames_since_update += 1 unless @frames_since_update > @frame_interval - 1

    @frames_since_update = 0
    if @index < @animation.length - 1
      @index += 1
    else
      @index = 0
    end
  end
end
