module PIX
  module Features
    class Clock < Screen

      include Drawings

      COLOR = 7
      COLOR_DOT = 3

      def update
        @digits = Time.new.strftime("%k%M").split('')
      end

      def render
        clear

        draw(Digits, @digits[0], 0, 0, COLOR)
        draw(Digits, @digits[1], 4, 0, COLOR)
        draw(Digits, @digits[2], 9, 9, COLOR)
        draw(Digits, @digits[3], 13, 9, COLOR)

        put_pix(12, 3, COLOR_DOT)
        put_pix(3, 12, COLOR_DOT)
      end
    end
  end
end
