#pragma once

#include "screen.h"
#include <cstdint>

using namespace std;

class Clock : public Screen {
private:
  Platform *platform;

public:
  Clock(Platform *);
  ~Clock();
  PixelData *update();
};
