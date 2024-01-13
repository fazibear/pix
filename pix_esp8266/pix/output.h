#pragma once

#include "screen.h"
#include <cstdint>

class Output {
public:
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint_fast8_t, uint_fast8_t, bool, bool, bool){};
};
