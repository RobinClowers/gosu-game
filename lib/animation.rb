class Animation
  include Gosu

  def initialize(path, width:, height:, length:, frame_rate: 2, rows: 1, columns: 8)
    @tiles = Image.load_tiles(path, width, height)
    @length = length
    @frame_rate = frame_rate
    @frames_since_update = 0
    @index = 0
    @row_count = rows
    @column_count = columns
    @animation = yield(tile_rows)
  end

  def draw(direction, x, y, animate: true)
    @frame = @animation[direction][@index]
    @frame.draw_rot(x, y, ZIndex::Player, 0.0)
    return false unless animate
    update_index
    @index != 0
  end

  def in_progress?
    @index != 0
  end

  def draw_sheet(x, y)
    row_index = 0
    @animation.values.each do |row|
      row.each_with_index do |frame, index|
        frame.draw_rot(x + index * frame.width, y + frame.height * row_index, ZIndex::Player, 0.0)
      end
      row_index += 1
    end
  end

  def update_index
    return @frames_since_update += 1 unless @frames_since_update > @frame_rate - 1

    @frames_since_update = 0
    if @index < @length - 1
      @index += 1
    else
      @index = 0
    end
  end

  def tile_rows
    @rows ||= @row_count.times.map { |row|
      offset = row * @column_count
      @tiles[offset..offset + @column_count - 1]
    }
  end
end
