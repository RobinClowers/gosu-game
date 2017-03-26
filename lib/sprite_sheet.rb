require_relative 'animation'

class SpriteSheet
  include Gosu

  def initialize(path, width:, height:, rows: 1, columns: 8)
    @tiles = Image.load_tiles(path, width, height)
    @row_count = rows
    @column_count = columns
    @animations = yield(tile_rows)
  end

  def draw(key, x, y, z_index: ZIndex::Player, animate: true, angle: 0)
    @animations[key].draw(x, y, z_index: z_index, animate: animate, angle: angle)
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

  def tile_rows
    @rows ||= @row_count.times.map { |row|
      offset = row * @column_count
      @tiles[offset..offset + @column_count - 1]
    }
  end
end
