module MouseHandler
  def mouse_over?(*args)
    case args.length
      when 3
        over_circle?(*args)
      when 4
        over_box?(*args)
      else
        raise "over takes 3 or 4 arguments, recieved: #{args.inspect}"
    end
  end

  def over_box?(x, y, width, height)
    if mouse_x >= x && mouse_x <= x + width && mouse_y >= y && mouse_y <= y + height then
      return true
    else
      return false
    end
  end

  def over_circle?(x, y, radius)
    if distance(x, y, mouse_x, mouse_y) <= radius then
      return true
    else
      return false
    end
  end
end
