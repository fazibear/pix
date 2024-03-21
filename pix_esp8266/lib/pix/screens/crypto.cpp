#include "crypto.h"
#include <cstdlib>

Crypto::Crypto(Platform *p) {
  platform = p;
  throttle = 4;
  refresh_every = 60 * 60 * 24;
  position = 16;
};

void Crypto::refresh() {
  ip = platform->fetch(
      "https://production.api.coindesk.com/v2/tb/price/ticker?assets=BTC,ETH");
  len = ip.length() * 4;
  screen_frames = len * throttle + 64;
};

void Crypto::update() {
  if (position < -len) {
    position = 16;
  }

  position--;

  platform->clear();

  Chars::put_char(platform, 'I', 4, 0, YELLOW);
  Chars::put_char(platform, 'P', 8, 0, YELLOW);

  for (int j = 0; j < 5; j++) {
    size_t i = j + (position / -4);
    if (i >= 0 && i < ip.length()) {
      Chars::put_char(platform, ip[i], (i * 4) + position, 9, WHITE);
    }
  }
};
