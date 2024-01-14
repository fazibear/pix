#include "random.h"
#include <cstdlib>

Random::Random() { pixel_data = new PixelData[16]{{{0}}}; };

PixelData *Random::update() {
  int x = rand() % 16;
  int y = rand() % 16;
  Pixel c(rand() % 8);
  *pixel_data[x][y] = c;

  return pixel_data;
};
