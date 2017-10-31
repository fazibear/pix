module PIX
  module Drawings
    module Template
      def put_template(x, y)
        [
          [x+2, y+0],
          [x+1, y+1], [x+2, y+1],
          [x+0, y+2], [x+2, y+2],
          [x+2, y+3],
          [x+2, y+4],
          [x+2, y+5],
          [x+2, y+6]
        ].each do |xx, yy|
          put_pix(xx, yy, color)
        end
      end
    end
  end
end
