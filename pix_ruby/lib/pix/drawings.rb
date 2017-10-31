module PIX
  module Drawings
    def draw(clazz, name, x, y, c = 7)
      clazz.new.send(method_name(name)).each_with_index do |line, yy|
        line.split('').each_with_index do |cc, xx|
          next if cc == " "
          cc = c if cc == "c"
          put_pix(xx+x, yy+y, cc.to_i)
        end
      end
    end


    def method_name(name)
      "data_" + name
        .downcase
        .gsub(' ', 'space')
        .gsub('-', 'minus')
    end
  end
end
