module PIX
  module Drawings
    class WeatherIcons
      def data_sun
        [
          '  3  3  ',
          '        ',
          '3  33  3',
          '  3333  ',
          '  3333  ',
          '3  33  3',
          '        ',
          '  3  3  ',
        ]
      end

      def data_moon
        [
          '   777  ',
          '     77 ',
          '      77',
          '      77',
          '      77',
          '      77',
          '     77 ',
          '   777  ',
        ]
      end

      def data_cloud
        [
          '     777  ',
          '   777777 ',
          ' 777777777',
          '7777777777',
          '7777777777',
          '777777777 ',
          ' 77  77   ',
        ]
      end

      def data_rain
        [
          '6 6 6 ',
          ' 6 6 6',
        ]
      end

      def data_snow
        [
          '7    7 ',
          '   7   ',
          ' 7    7',
        ]
      end
    end
  end
end
