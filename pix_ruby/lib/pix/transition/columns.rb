module PIX
  class Transition
    class Columns < Transition
      include Rules

      def render
        RULES.sample.each do |l|
          @output.display(line(l))
          sleep 0.02
        end
      end

      def line(l)
        out = []

        16.times do |i|
          line_el = []

          l.each do |line|
            s = line[0] == "o" ? @old : @new
            n = line[1..-1].to_i

            line_el << s[i][n]
          end
          out << line_el
        end

        out
      end
    end
  end
end
