#include "eth.h"
#include <cstdlib>
#include <cstring>

ETH::ETH(Platform *p) {
  platform = p;
  throttle = 4;
  refresh_every = 60 * 60;
  position = 16;
  refreshed_at = 0;
};

// #define URL "https://api.coindesk.com/v2/tb/price/ticker?assets=ETH"
// #define PRICE "data"]["BTC"]["ohlc"]["c"
// #define CHANGE "data"]["BTC"]["change"]["percent"

#define ETH_URL "https://api.coincap.io/v2/assets/ethereum"
#define ETH_PRICE "data"]["priceUsd"
#define ETH_CHANGE "data"]["changePercent24Hr"

void ETH::refresh() {
  std::string json = platform->fetch(ETH_URL);

  if (json != "error") {
    JsonDocument doc;
    deserializeJson(doc, json);

    float price_f = doc[ETH_PRICE].as<float>();
    float change_f = doc[ETH_CHANGE].as<float>();

    info = "ETH: " + std::to_string((int)std::round(price_f)) + " USD " +
           (change_f > 0 ? "+" : "") + std::to_string((int)std::round(change_f)) + "% ";
  } else {
    info = "Error fetching data";
  }

  position = 16;
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
