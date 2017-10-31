module PIX
  module Output
    class Terminal
      def display(screen)
        clear
        print(screen)
      end

      def clear
        puts("\e[H\e[2J")
      end

      def print(screen)
        screen.each do |line|
          puts prepare_line(line)
        end
      end

      def prepare_line(line)
        line.map do |pix|
          "■ ".colorize(map_screen_color(pix))
        end.join('')
      end

      def map_screen_color(color)
        {
          0 => :black,
          1 => :red,
          2 => :green,
          3 => :yellow,
          4 => :blue,
          5 => :magenta,
          6 => :cyan,
          7 => :white
        }[color]
      end
    end
  end
end
