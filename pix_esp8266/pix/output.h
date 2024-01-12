#pragma once

#include <cstdint>

class Output {
public:
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint_fast8_t x, uint_fast8_t y, uint_fast8_t r,
                              uint_fast8_t g, uint_fast8_t b){};
};
