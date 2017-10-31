module PIX
  class Transition
    class None # < Transition
      def render
        @output.display(@new)
      end
    end
  end
end
