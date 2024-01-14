#pragma once
#include <cstdint>

class Output {
public:
  virtual inline void init(){};
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint8_t, uint8_t, bool, bool, bool){};
};
