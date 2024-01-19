#include "crab.h"

Crab::Crab(Platform *p) {
  platform = p;
  dir_x = true;
  dir_y = true;
  frame = true;
  x = rand() % (16 - CRAB_WIDTH);
  y = rand() % (16 - CRAB_HEIGHT);
  color = rand() % 6 + 1;
  change_color = false;
  frame_counter = 0;
};

void Crab::update() {
  frame_counter++;

  if (frame_counter == 10) {
    frame_counter = 0;
  } else {
    return;
  }

  change_color = false;
  frame = !frame;

  dir_y ? y++ : y--;
  if (y == 0 or y == 16 - CRAB_HEIGHT) {
    dir_y = !dir_y;
    change_color = true;
  }

  dir_x ? x++ : x--;
  if (x == 0 or x == 16 - CRAB_WIDTH) {
    dir_x = !dir_x;
    change_color = true;
  }

  for (int sx = 0; sx < 16; sx++) {
    for (int sy = 0; sy < 16; sy++) {
      if (sx >= x and sx < x + CRAB_WIDTH and sy >= y and
          sy < y + CRAB_HEIGHT) {
        platform->set_dot(
            sx, sy, (frame ? crab_0 : crab_1)[sy - y][sx - x] ? color : BLACK);
      } else {
        platform->set_dot(sx, sy, BLACK);
      }
    }
  }

  if (change_color) {
    color++;
    if (color > 6) {
      color = 1;
    }
  }
};
