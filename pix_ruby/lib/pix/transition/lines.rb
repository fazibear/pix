module PIX
  class Transition
    class Lines < Transition
      include Rules

      def render
        RULES.sample.each do |l|
          @output.display(line(l))
          sleep 0.02
        end
      end

      def line(l)
        out = []

        l.each do |line|
          s = line[0] == "o" ? @old : @new
          n = line[1..-1].to_i

          out << s[n]
        end

        out
      end
    end
  end
end
