#include "clock.h"
#include "chars.h"

Clock::Clock(Platform *p) { platform = p; }

void Clock::update() {
  Time now = platform->get_time();
  struct tm *tm = localtime(&now);

  char sec = tm->tm_sec;

  platform->clear();

  Chars::put_char(platform, '0' + (tm->tm_hour / 10), 1, 1, 2);
  Chars::put_char(platform, '0' + (tm->tm_hour % 10), 5, 1, 2);

  Chars::put_char(platform, '0' + (tm->tm_min / 10), 8, 8, 2);
  Chars::put_char(platform, '0' + (tm->tm_min % 10), 12, 8, 2);

  if (tm->tm_sec % 2 == 0) {
    platform->set_dot(3, 11, 3);
    platform->set_dot(4, 12, 3);

    platform->set_dot(11, 3, 3);
    platform->set_dot(12, 4, 3);
  } else {
    platform->set_dot(3, 12, 3);
    platform->set_dot(4, 11, 3);

    platform->set_dot(11, 4, 3);
    platform->set_dot(12, 3, 3);
  }

  char s1, s2, s3, s4, s5 = 0;

  s1 = sec < 8 ? sec : 8;

  s2 = sec < 23 ? sec - 8 : 15;
  s3 = sec < 38 ? sec - 23 : 15;
  s4 = sec < 53 ? sec - 38 : 15;
  s5 = sec < 60 ? sec - 53 : 8;

  for (int i = 0; i < s1; i++) {
    platform->set_dot(8 + i, 0, 7);
  }

  for (int i = 0; i < s2; i++) {
    platform->set_dot(15, i + 1, 7);
  }

  for (int i = 0; i < s3; i++) {
    platform->set_dot(14 - i, 15, 7);
  }

  for (int i = 0; i < s4; i++) {
    platform->set_dot(0, 14 - i, 7);
  }

  for (int i = 0; i < s5; i++) {
    platform->set_dot(i + 1, 0, 7);
  }
};
