#pragma once

#include <platform.h>

class Screen {
public:
  int screen_frames = 500;

  virtual inline void update(){};
};
