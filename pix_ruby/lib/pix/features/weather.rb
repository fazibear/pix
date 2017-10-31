module PIX
  module Features
    class Weather < Screen

      include Drawings

      COLOR = 2
      URL = "https://api.openweathermap.org/data/2.5/weather?q=Warsaw,pl&units=metric&appid=#{OWM_KEY}"
      TIMEOUT = 60*5

      def update
        if @updated && Time.now - @updated > TIMEOUT
          @data = nil
          @updated = nil
        end
        @data ||= fetch_data
        @updated ||= Time.now
      rescue
        :nothing
      end

      def render
        icon = data[1][2] == 'd' ? 'sun' : 'moon'
        type = data[1][0..1]

        if icon == 'sun'
          clear(4)
        else
          clear(0)
        end

        case type
        when "01"
          draw(WeatherIcons, icon, 8, 0)
        when "02"
          draw(WeatherIcons, icon, 8, 0)
          draw(WeatherIcons, "cloud", 0, 1)
        when "03", "04"
          draw(WeatherIcons, "cloud", 0, 1)
        when "09"
          draw(WeatherIcons, "cloud", 0, 1)
          draw(WeatherIcons, "rain", 3, 8)
        when "10"
          draw(WeatherIcons, icon, 8, 0)
          draw(WeatherIcons, "cloud", 0, 1)
          draw(WeatherIcons, "rain", 3, 8)
        when "11",
          draw(WeatherIcons, "cloud", 0, 1)
        when "13d"
          draw(WeatherIcons, "cloud", 0, 1)
          draw(WeatherIcons, "snow", 2, 8)
        end

        draw(Digits, data[0][0], 5, 9, COLOR)
        draw(Digits, data[0][1], 9, 9, COLOR)
        draw(Digits, data[0][2], 13, 9, COLOR)
      end

      def data
        [
          ("%*d" % [3 , @data["main"]["temp"]]).split(''),
          @data["weather"].first["icon"]
        ]
      end

      def fetch_data
        open(URL) do |resp|
          JSON.parse(resp.read)
        end
      end
    end
  end
end
