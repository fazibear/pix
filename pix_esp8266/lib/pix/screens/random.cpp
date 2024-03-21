#include "random.h"
#include <cstdlib>

Random::Random(Platform *p) {
  screen_frames = 50;
  platform = p;
};

void Random::update() {
  int x = rand() % 16;
  int y = rand() % 16;
  int c(rand() % 8);

  platform->set_dot(x, y, c);
};
