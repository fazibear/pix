#pragma once

#include "../screen.h"

class Random : public Screen {
private:
public:
  Random();
  ~Random();
  PixelData *update();
};
