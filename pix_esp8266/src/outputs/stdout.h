#pragma once

#include "../output.h"
#include <cstdint>

class StdOut : public Output {
public:
  StdOut();
  ~StdOut();

  void clean();
  void set_dot(uint_fast8_t x, uint_fast8_t y, uint_fast8_t r, uint_fast8_t g,
               uint_fast8_t b);
  void draw();

private:
  char pixel_data[16][16] = {{0}};
};
