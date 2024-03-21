#pragma once

#include "screen.h"
#include "time.h"

using namespace std;

class Clock : public Screen {
private:
  Platform *platform;

public:
  Clock(Platform *);
  ~Clock();
  void update();
};
