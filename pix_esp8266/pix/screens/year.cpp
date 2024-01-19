#include "year.h"

Year::Year(Platform *p) {
  platform = p;
  pixel_data = new PixelData[16]{{{0}}};
}

PixelData *Year::update() {
  // Time now = platform->get_time();
  // struct tm *tm = localtime(&now);

  // int percent = 5;

  for (uint8_t x = 0; x < 16; x++) {
    for (uint8_t y = 0; y < 16; y++) {
      *pixel_data[y][x] = 0;
    }
  }

  *pixel_data[12][0] = 7;
  *pixel_data[13][0] = 7;

  *pixel_data[12][15] = 7;
  *pixel_data[13][15] = 7;

  *pixel_data[11][1] = 7;
  *pixel_data[11][2] = 7;
  *pixel_data[11][3] = 7;
  *pixel_data[11][4] = 7;
  *pixel_data[11][5] = 7;
  *pixel_data[11][6] = 7;
  *pixel_data[11][7] = 7;
  *pixel_data[11][8] = 7;
  *pixel_data[11][9] = 7;
  *pixel_data[11][10] = 7;
  *pixel_data[11][11] = 7;
  *pixel_data[11][12] = 7;
  *pixel_data[11][13] = 7;
  *pixel_data[11][14] = 7;

  *pixel_data[14][1] = 7;
  *pixel_data[14][2] = 7;
  *pixel_data[14][3] = 7;
  *pixel_data[14][4] = 7;
  *pixel_data[14][5] = 7;
  *pixel_data[14][6] = 7;
  *pixel_data[14][7] = 7;
  *pixel_data[14][8] = 7;
  *pixel_data[14][9] = 7;
  *pixel_data[14][10] = 7;
  *pixel_data[14][11] = 7;
  *pixel_data[14][12] = 7;
  *pixel_data[14][13] = 7;
  *pixel_data[14][14] = 7;

  // for (uint8_t x = 0; x < 14 / percent; x++) {
  //   *pixel_data[12][x + 1] = 2;
  //   *pixel_data[13][x + 1] = 2;
  // }

  // Chars::put_char(pixel_data, 'Y', 0, 2, 4);
  // Chars::put_char(pixel_data, '%', 13, 2, 3);
  //  if (percent > 10) {
  //      Chars::put_char(pixel_data, '0' + percent / 10, 5, 2, 3);
  // }
  //   Chars::put_char(pixel_data, '0' + percent % 10, 9, 2, 3);

  return pixel_data;
};
