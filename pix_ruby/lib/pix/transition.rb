module PIX
  class Transition
    def initialize(output)
      @output = output
    end

    def run(new, old = nil)
      @old ||= old || Screen.new.screen
      @new = new
      render
      @old = new
    end

    def render
      transitions.sample.new(@output).run(@new, @old)
    end

    def transitions
      self.class.constants.reduce([]) do |acc, c|
        clazz = self.class.const_get(c)
        if clazz.is_a?(Class) && clazz < Transition
          acc << clazz
        end
        acc
      end
    end
  end
end
