#pragma once

#include "screen.h"
#include <cstdint>

class Output {
public:
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint_fast8_t x, uint_fast8_t y, Pixel pixel){};
};
