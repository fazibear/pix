#include "btc.h"
#include <cstdlib>
#include <cstring>

BTC::BTC(Platform *p) {
  platform = p;
  throttle = 4;
  refresh_every = 60 * 60;
  position = 16;
  refreshed_at = 0;
};

// #define URL "https://api.coindesk.com/v2/tb/price/ticker?assets=BTC"
// #define PRICE "data"]["BTC"]["ohlc"]["c"
// #define CHANGE "data"]["BTC"]["change"]["percent"

#define URL "https://api.coincap.io/v2/assets/bitcoin"
#define PRICE "data"]["priceUsd"
#define CHANGE "data"]["changePercent24Hr"

void BTC::refresh() {
  std::string json = platform->fetch(URL);

  if (json != "error") {
    JsonDocument doc;
    deserializeJson(doc, json);

    float price_f = doc[PRICE].as<float>();
    float change_f = doc[CHANGE].as<float>();

    info = "BTC: " + std::to_string((int)std::round(price_f)) + " USD " +
           std::to_string((int)std::round(change_f)) + "% ";
  } else {
    info = "Error fetching data";
  }

  position = 16;
  len = info.length() * 4;
  screen_frames = len * throttle + 64;
};

void BTC::update() {
  if (position < -len) {
    position = 16;
  }

  position--;

  platform->clear();

  for (int j = 0; j < 5; j++) {
    size_t i = j + (position / -4);
    if (i >= 0 && i < info.length()) {
      Chars::put_char(platform, info[i], (i * 4) + position, 4, YELLOW);
    }
  }
};
