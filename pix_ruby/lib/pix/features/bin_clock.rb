module PIX
  module Features
    class BinClock < Screen

      include Drawings

      COLOR_ON = 6
      COLOR_OFF = 4
      COLOR_DOT = 3
      def update
        @bits = Time
                  .new
                  .strftime("%H%M")
                  .split('')
                  .map { |digit| ('%04b' % digit).split('') }
      end

      def render
        clear

        [1,4,10,13].each_with_index do |x, i|
          @bits[i].each_with_index do |bit, y|
            color = bit == "1" ? COLOR_ON : COLOR_OFF
            y = y*4+1

            put_pix(x, y, color)
            put_pix(x+1, y, color)
            put_pix(x, y+1, color)
            put_pix(x+1, y+1, color)
          end
        end

        put_pix(7, 4, COLOR_DOT)
        put_pix(8, 5, COLOR_DOT)
        put_pix(7, 5, COLOR_DOT)
        put_pix(8, 4, COLOR_DOT)

        put_pix(7, 10, COLOR_DOT)
        put_pix(8, 11, COLOR_DOT)
        put_pix(7, 11, COLOR_DOT)
        put_pix(8, 10, COLOR_DOT)
      end
    end
  end
end
