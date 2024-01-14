#pragma once

#include "c_types.h"

class Output {
public:
  virtual inline void init(){};
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint8, uint8, bool, bool, bool){};
};
