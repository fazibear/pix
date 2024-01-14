#include "crab.h"

Crab::Crab() {
  pixel_data = new PixelData[16]{{{0}}};
  dir_x = true;
  dir_y = true;
  frame = true;
  x = rand() % (16 - CRAB_WIDTH);
  y = rand() % (16 - CRAB_HEIGHT);
  color = rand() % 7 + 1;
};

PixelData *Crab::update() {
  frame_counter++;

  if (frame_counter == 20) {
    frame_counter = 0;
  } else {
    return pixel_data;
  }

  frame = !frame;

  dir_y ? y++ : y--;
  if (y == 0 or y == 16 - CRAB_HEIGHT) {
    dir_y = !dir_y;
    color++;
  }

  dir_x ? x++ : x--;
  if (x == 0 or x == 16 - CRAB_WIDTH) {
    dir_x = !dir_x;
    color++;
  }

  if (color > 7) {
    color = 1;
  }

  for (int sx = 0; sx < 16; sx++) {
    for (int sy = 0; sy < 16; sy++) {
      if (sx >= x and sx < x + CRAB_WIDTH and sy >= y and
          sy < y + CRAB_HEIGHT) {
        *pixel_data[sy][sx] =
            (frame ? crab_0 : crab_1)[sy - y][sx - x] ? color : 0;
      } else {
        *pixel_data[sy][sx] = 0;
      }
    }
  }

  return pixel_data;
};
