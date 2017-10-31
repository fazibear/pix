require 'open-uri'
require 'json'

require_relative '../config'

[
  Dir["#{__dir__}/pix/*.rb"],
  Dir["#{__dir__}/pix/drawings/*.rb"],
  Dir["#{__dir__}/pix/features/*.rb"],
  Dir["#{__dir__}/pix/output/*.rb"],
  "#{__dir__}/pix/transition/rules.rb",
  Dir["#{__dir__}/pix/transition/*.rb"],
].flatten.each do |file|
  require file
end

module PIX
  OUT = if Output::Matrix.supported?
          Output::Matrix.new
        else
          require 'colorize'
          Output::Terminal.new
        end

  TRANS = Transition.new(OUT)

  FEATURES = {
    Features::Clock.new => 10,
    Features::Weather.new => 10,
    Features::Biorythm.new => 10,
    Features::BinClock.new => 10,
  }

  while true
    FEATURES.each do |feature, time|
      TRANS.run(feature.refresh.screen)
      sleep time
    end
  end
end
