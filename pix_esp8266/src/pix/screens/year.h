#pragma once

#include "chars.h"
#include "cmath"
#include "screen.h"
#include "time.h"

class Year : public Screen {
private:
  int dots;
  int percent;
  Platform *platform;

public:
  Year(Platform *);
  ~Year();
  void update();
  void refresh();
};
