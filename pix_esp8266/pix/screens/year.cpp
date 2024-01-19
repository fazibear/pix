#include "year.h"

Year::Year(Platform *p) {
  platform = p;
  frame_counter = 254;
  percent = 0;
  screen_frames = 100;
}

void Year::update() {
  frame_counter++;

  if (frame_counter > 254) {
    frame_counter = 0;
    Time now = platform->get_time();
    percent = (now->tm_yday * 100) / 365;
  }

  platform->clear();
  platform->set_dot(0, 12, WHITE);
  platform->set_dot(0, 13, WHITE);

  platform->set_dot(15, 12, WHITE);
  platform->set_dot(15, 13, WHITE);

  platform->set_dot(1, 11, WHITE);
  platform->set_dot(2, 11, WHITE);
  platform->set_dot(3, 11, WHITE);
  platform->set_dot(4, 11, WHITE);
  platform->set_dot(5, 11, WHITE);
  platform->set_dot(6, 11, WHITE);
  platform->set_dot(7, 11, WHITE);
  platform->set_dot(8, 11, WHITE);
  platform->set_dot(9, 11, WHITE);
  platform->set_dot(10, 11, WHITE);
  platform->set_dot(11, 11, WHITE);
  platform->set_dot(12, 11, WHITE);
  platform->set_dot(13, 11, WHITE);
  platform->set_dot(14, 11, WHITE);

  platform->set_dot(1, 14, WHITE);
  platform->set_dot(2, 14, WHITE);
  platform->set_dot(3, 14, WHITE);
  platform->set_dot(4, 14, WHITE);
  platform->set_dot(5, 14, WHITE);
  platform->set_dot(6, 14, WHITE);
  platform->set_dot(7, 14, WHITE);
  platform->set_dot(8, 14, WHITE);
  platform->set_dot(9, 14, WHITE);
  platform->set_dot(10, 14, WHITE);
  platform->set_dot(11, 14, WHITE);
  platform->set_dot(12, 14, WHITE);
  platform->set_dot(13, 14, WHITE);
  platform->set_dot(14, 14, WHITE);

  for (uint8_t x = 0; x < 14 / percent; x++) {
    platform->set_dot(x + 1, 12, 3);
    platform->set_dot(x + 1, 13, 3);
  }

  Chars::put_char(platform, 'Y', 0, 2, BLUE);
  Chars::put_char(platform, '%', 13, 2, YELLOW);
  if (percent > 10) {
    Chars::put_char(platform, '0' + percent / 10, 5, 2, YELLOW);
  }
  Chars::put_char(platform, '0' + percent % 10, 9, 2, YELLOW);
};
