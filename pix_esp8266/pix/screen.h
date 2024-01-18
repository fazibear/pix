#pragma once

#include "platform.h"
#include <bitset>

typedef std::bitset<3> Pixel;
typedef Pixel PixelData[16][16];

class Screen {
public:
  int screen_frames = 500;
  PixelData *pixel_data;

  virtual inline PixelData *update() { return pixel_data; };
};
