module PIX
  module Output
    class Matrix

      PIX_FILE = '/sys/pix/dot'

      def self.supported?
        File.exist?(PIX_FILE)
      end

      def initialize
        @file = File.open(PIX_FILE, 'w')
      end

      def display(screen)
        screen.each_with_index do |line, y|
          line.each_with_index do |pix, x|
            write(x, y, pix)
          end
        end
      end

      def write(x, y, color)
        case color
        when 0 then write_rgb(x, y, 0, 0, 0)
        when 1 then write_rgb(x, y, 1, 0, 0)
        when 2 then write_rgb(x, y, 0, 1, 0)
        when 3 then write_rgb(x, y, 1, 1, 0)
        when 4 then write_rgb(x, y, 0, 0, 1)
        when 5 then write_rgb(x, y, 1, 0, 1)
        when 6 then write_rgb(x, y, 0, 1, 1)
        when 7 then write_rgb(x, y, 1, 1, 1)
        else nil
        end
      end

      def write_rgb(x, y, r, g, b)
        @file.print("#{x} #{y} #{r} #{g} #{b}")
        @file.flush
      end
    end
  end
end
