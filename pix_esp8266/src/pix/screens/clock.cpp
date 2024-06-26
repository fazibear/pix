#include "clock.h"
#include "chars.h"

Clock::Clock(Platform *p) {
  platform = p;
  screen_frames = 60 * 5;
}

void Clock::update() {
  Time now = platform->get_datetime();

  platform->clear();

  Chars::put_char(platform, '0' + (now->tm_hour / 10), 1, 1, GREEN);
  Chars::put_char(platform, '0' + (now->tm_hour % 10), 5, 1, GREEN);

  Chars::put_char(platform, '0' + (now->tm_min / 10), 8, 8, GREEN);
  Chars::put_char(platform, '0' + (now->tm_min % 10), 12, 8, GREEN);

  if (now->tm_sec % 2 == 0) {
    platform->set_dot(3, 10, YELLOW);
    platform->set_dot(4, 11, YELLOW);
    platform->set_dot(5, 12, YELLOW);

    platform->set_dot(10, 5, YELLOW);
    platform->set_dot(11, 4, YELLOW);
    platform->set_dot(12, 3, YELLOW);

  } else {
    platform->set_dot(3, 12, YELLOW);
    platform->set_dot(4, 11, YELLOW);
    platform->set_dot(5, 10, YELLOW);

    platform->set_dot(10, 3, YELLOW);
    platform->set_dot(11, 4, YELLOW);
    platform->set_dot(12, 5, YELLOW);
  }

  for (int i = 0; i < now->tm_sec; i++) {
    std::tuple<int, int> coord = secords[i];
    platform->set_dot(std::get<0>(coord), std::get<1>(coord), WHITE);
  }
};
