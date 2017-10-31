module PIX
  class Screen
    attr_reader :screen

    def empty(color = 0)
      Array.new(16){ Array.new(16) { color }}
    end

    def initialize
      @screen = empty
    end

    def put_pix(x, y, color)
      return if x < 0
      return if x > 15
      return if y < 0
      return if y > 15
      return if color < 0
      return if color > 7

      @screen[y][x] = color
    end

    def clear(color = 0)
      @screen = empty(color)
    end

    def update; end
    def render; end

    def refresh
      update
      render
      self
    end
  end
end
