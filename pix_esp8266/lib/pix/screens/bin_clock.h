#pragma once

#include "screen.h"
#include "time.h"

class BinClock : public Screen {
private:
  Platform *platform;

public:
  BinClock(Platform *);
  ~BinClock();
  void update();
};
