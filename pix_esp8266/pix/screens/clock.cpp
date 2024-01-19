#include "clock.h"
#include "chars.h"

Clock::Clock(Platform *p) {
  platform = p;
  pixel_data = new PixelData[16]{{{0}}};
}

PixelData *Clock::update() {
  Time now = platform->get_time();
  struct tm *tm = localtime(&now);

  for (uint8_t x = 0; x < 16; x++) {
    for (uint8_t y = 0; y < 16; y++) {
      *pixel_data[y][x] = 0;
    }
  }

  Chars::put_char(pixel_data, '0' + (tm->tm_hour / 10), 1, 1, 2);
  Chars::put_char(pixel_data, '0' + (tm->tm_hour % 10), 5, 1, 2);

  Chars::put_char(pixel_data, '0' + (tm->tm_min / 10), 8, 8, 2);
  Chars::put_char(pixel_data, '0' + (tm->tm_min % 10), 12, 8, 2);

  if (tm->tm_sec % 2 == 0) {
    *pixel_data[3][11] = 3;
    *pixel_data[4][12] = 3;

    *pixel_data[11][3] = 3;
    *pixel_data[12][4] = 3;
  } else {
    *pixel_data[3][12] = 3;
    *pixel_data[4][11] = 3;

    *pixel_data[12][3] = 3;
    *pixel_data[11][4] = 3;
  }

  return pixel_data;
};
