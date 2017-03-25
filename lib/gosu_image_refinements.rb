class Gosu::Image
  def to_rmagick
    size = "#{width}x#{height}"
    Magick::Image.from_blob(self.to_blob) {
      self.format = "RGBA"
      self.depth = 8
      self.size = size
    }.first
  end
end
