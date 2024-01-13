#include "crab.h"

Crab::Crab() {
  x = 0;
  y = 0;
  dir_x = true;
  dir_y = true;
  color = 0;
};

PixelData *Crab::update() {
  if (x <= 0 or x >= 16 - CRAB_WIDTH) {
    dir_x = !dir_x;
    // randomize color
  }
  dir_x ? x++ : x--;

  if (y <= 0 or y >= 16 - CRAB_HEIGHT) {
    dir_y = !dir_y;
    // randomize color
  }
  dir_y ? y++ : y--;

  return pixel_data;
};
