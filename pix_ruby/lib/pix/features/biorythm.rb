module PIX
  module Features
    class Biorythm < Screen

      include Drawings
      include Math

      B1 = Date.parse(BIO_BIRTH_1)
      B2 = Date.parse(BIO_BIRTH_2)

      def update
        @p1 = sin((2*PI*(Date.today - B1).to_i)/23)*8
        @e1 = sin((2*PI*(Date.today - B1).to_i)/28)*8
        @i1 = sin((2*PI*(Date.today - B1).to_i)/33)*8

        @p2 = sin((2*PI*(Date.today - B2).to_i)/23)*8
        @e2 = sin((2*PI*(Date.today - B2).to_i)/28)*8
        @i2 = sin((2*PI*(Date.today - B2).to_i)/33)*8
      end

      def render
        clear

        draw(Letters, BIO_LETTER_1, 0, 0, 7)

        draw_bio(5, 2, @p1.to_i)
        draw_bio(6, 1, @e1.to_i)
        draw_bio(7, 4, @i1.to_i)

        draw(Letters, BIO_LETTER_2, 0, 8, 7)

        draw_bio(13, 2, @p2.to_i)
        draw_bio(14, 1, @e2.to_i)
        draw_bio(15, 4, @i2.to_i)
      end

      def draw_bio(line, color, value)
        if value > 0
          (8..value+7)
        else
          (8+value..7)
        end.each do |p|
          put_pix(p, line, color)
        end
      end
    end
  end
end
