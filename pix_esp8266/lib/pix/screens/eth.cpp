#include "eth.h"
#include <cstdlib>
#include <cstring>

ETH::ETH(Platform *p) {
  platform = p;
  throttle = 4;
  refresh_every = 60 * 60;
  position = 16;
};

void ETH::refresh() {
  std::string json = platform->fetch(
      "https://production.api.coindesk.com/v2/tb/price/ticker?assets=ETH");

  JsonDocument doc;
  deserializeJson(doc, json);

  float price_f = doc["data"]["ETH"]["ohlc"]["c"].as<float>();
  float change_f = doc["data"]["ETH"]["change"]["percent"].as<float>();

  info = "ETH: " + std::to_string((int)std::round(price_f)) + " USD " +
         std::to_string((int)std::round(change_f)) + "% ";

  len = info.length() * 4;

  screen_frames = len * throttle + 64;
};

void ETH::update() {
  if (position < -len) {
    position = 16;
  }

  position--;

  platform->clear();

  for (int j = 0; j < 5; j++) {
    size_t i = j + (position / -4);
    if (i >= 0 && i < info.length()) {
      Chars::put_char(platform, info[i], (i * 4) + position, 4, BLUE);
    }
  }
};
