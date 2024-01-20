#include "ip.h"
#include <cstdlib>

Ip::Ip(Platform *p) {
  throttle = 4;
  screen_frames = 50;
  frame_counter = 999;
  platform = p;
  ip = "123.123.123.123";
  len = ip.length() * 4;
  position = 16;
  screen_frames = len * throttle;
};

void Ip::update() {
  frame_counter++;

  if (frame_counter == 1000) {
    ip = platform->fetch("http://ipinfo.io/ip");
    frame_counter = 0;
  }

  position--;

  if (position < -len) {
    position = 15;
  }

  platform->clear();

  Chars::put_char(platform, 'I', 4, 0, YELLOW);
  Chars::put_char(platform, 'P', 8, 0, YELLOW);

  for (int j = 0; j < 5; j++) {
    int i = j + (position / -4);
    if (i >= 0 && i < ip.length()) {
      Chars::put_char(platform, ip[i], (i * 4) + position, 9, WHITE);
    }
  }
};
