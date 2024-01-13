#pragma once

#include <bitset>

typedef std::bitset<3> Pixel;
typedef Pixel PixelData[16][16];

class Screen {
public:
  PixelData *pixel_data;

  virtual inline PixelData *update() { return pixel_data; };
};
