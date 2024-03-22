#pragma once

#include "screen.h"
#include "time.h"

class Clock : public Screen {
private:
  Platform *platform;

public:
  Clock(Platform *);
  ~Clock();
  void update();
};
