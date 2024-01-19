#pragma once

#include "../screen.h"

class Random : public Screen {
private:
  Platform *platform;

public:
  Random(Platform *);
  ~Random();
  void update();
};
