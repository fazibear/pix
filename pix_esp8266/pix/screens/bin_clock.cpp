#include "bin_clock.h"
// #include "Arduino.h"

BinClock::BinClock(Platform *p) { platform = p; }

void BinClock::update() {
  Time now = platform->get_time();

  platform->clear();

  bool h11 = (now->tm_hour / 10) & 1;
  bool h12 = (now->tm_hour / 10) & 2;
  bool h13 = (now->tm_hour / 10) & 4;
  bool h14 = (now->tm_hour / 10) & 8;

  bool h21 = (now->tm_hour % 10) & 1;
  bool h22 = (now->tm_hour % 10) & 2;
  bool h23 = (now->tm_hour % 10) & 4;
  bool h24 = (now->tm_hour % 10) & 8;

  bool m11 = (now->tm_min / 10) & 1;
  bool m12 = (now->tm_min / 10) & 2;
  bool m13 = (now->tm_min / 10) & 4;
  bool m14 = (now->tm_min / 10) & 8;

  bool m21 = (now->tm_min % 10) & 1;
  bool m22 = (now->tm_min % 10) & 2;
  bool m23 = (now->tm_min % 10) & 4;
  bool m24 = (now->tm_min % 10) & 8;

  platform->set_dot(1, 1, h14 ? BLUE : GREEN);
  platform->set_dot(1, 2, h14 ? BLUE : GREEN);
  platform->set_dot(2, 1, h14 ? BLUE : GREEN);
  platform->set_dot(2, 2, h14 ? BLUE : GREEN);

  platform->set_dot(1, 5, h13 ? BLUE : GREEN);
  platform->set_dot(1, 6, h13 ? BLUE : GREEN);
  platform->set_dot(2, 5, h13 ? BLUE : GREEN);
  platform->set_dot(2, 6, h13 ? BLUE : GREEN);

  platform->set_dot(1, 9, h12 ? BLUE : GREEN);
  platform->set_dot(1, 10, h12 ? BLUE : GREEN);
  platform->set_dot(2, 9, h12 ? BLUE : GREEN);
  platform->set_dot(2, 10, h12 ? BLUE : GREEN);

  platform->set_dot(1, 13, h11 ? BLUE : GREEN);
  platform->set_dot(1, 14, h11 ? BLUE : GREEN);
  platform->set_dot(2, 13, h11 ? BLUE : GREEN);
  platform->set_dot(2, 14, h11 ? BLUE : GREEN);

  platform->set_dot(4, 1, h24 ? BLUE : GREEN);
  platform->set_dot(4, 2, h24 ? BLUE : GREEN);
  platform->set_dot(5, 1, h24 ? BLUE : GREEN);
  platform->set_dot(5, 2, h24 ? BLUE : GREEN);

  platform->set_dot(4, 5, h23 ? BLUE : GREEN);
  platform->set_dot(4, 6, h23 ? BLUE : GREEN);
  platform->set_dot(5, 5, h23 ? BLUE : GREEN);
  platform->set_dot(5, 6, h23 ? BLUE : GREEN);

  platform->set_dot(4, 9, h22 ? BLUE : GREEN);
  platform->set_dot(4, 10, h22 ? BLUE : GREEN);
  platform->set_dot(5, 9, h22 ? BLUE : GREEN);
  platform->set_dot(5, 10, h22 ? BLUE : GREEN);

  platform->set_dot(4, 13, h21 ? BLUE : GREEN);
  platform->set_dot(4, 14, h21 ? BLUE : GREEN);
  platform->set_dot(5, 13, h21 ? BLUE : GREEN);
  platform->set_dot(5, 14, h21 ? BLUE : GREEN);

  platform->set_dot(10, 1, m14 ? BLUE : GREEN);
  platform->set_dot(10, 2, m14 ? BLUE : GREEN);
  platform->set_dot(11, 1, m14 ? BLUE : GREEN);
  platform->set_dot(11, 2, m14 ? BLUE : GREEN);

  platform->set_dot(10, 5, m13 ? BLUE : GREEN);
  platform->set_dot(10, 6, m13 ? BLUE : GREEN);
  platform->set_dot(11, 5, m13 ? BLUE : GREEN);
  platform->set_dot(11, 6, m13 ? BLUE : GREEN);

  platform->set_dot(10, 9, m12 ? BLUE : GREEN);
  platform->set_dot(10, 10, m12 ? BLUE : GREEN);
  platform->set_dot(11, 9, m12 ? BLUE : GREEN);
  platform->set_dot(11, 10, m12 ? BLUE : GREEN);

  platform->set_dot(10, 13, m11 ? BLUE : GREEN);
  platform->set_dot(10, 14, m11 ? BLUE : GREEN);
  platform->set_dot(11, 13, m11 ? BLUE : GREEN);
  platform->set_dot(11, 14, m11 ? BLUE : GREEN);

  platform->set_dot(13, 1, m24 ? BLUE : GREEN);
  platform->set_dot(13, 2, m24 ? BLUE : GREEN);
  platform->set_dot(14, 1, m24 ? BLUE : GREEN);
  platform->set_dot(14, 2, m24 ? BLUE : GREEN);

  platform->set_dot(13, 5, m23 ? BLUE : GREEN);
  platform->set_dot(13, 6, m23 ? BLUE : GREEN);
  platform->set_dot(14, 5, m23 ? BLUE : GREEN);
  platform->set_dot(14, 6, m23 ? BLUE : GREEN);

  platform->set_dot(13, 9, m22 ? BLUE : GREEN);
  platform->set_dot(13, 10, m22 ? BLUE : GREEN);
  platform->set_dot(14, 9, m22 ? BLUE : GREEN);
  platform->set_dot(14, 10, m22 ? BLUE : GREEN);

  platform->set_dot(13, 13, m21 ? BLUE : GREEN);
  platform->set_dot(13, 14, m21 ? BLUE : GREEN);
  platform->set_dot(14, 13, m21 ? BLUE : GREEN);
  platform->set_dot(14, 14, m21 ? BLUE : GREEN);

  if (now->tm_sec % 2 == 0) {
    platform->set_dot(7, 4, YELLOW);
    platform->set_dot(8, 5, YELLOW);

    platform->set_dot(7, 10, YELLOW);
    platform->set_dot(8, 11, YELLOW);
  } else {
    platform->set_dot(8, 4, YELLOW);
    platform->set_dot(7, 5, YELLOW);

    platform->set_dot(7, 11, YELLOW);
    platform->set_dot(8, 10, YELLOW);
  }
};
