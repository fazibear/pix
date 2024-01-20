#pragma once

#include "chars.h"
#include "cmath"
#include "screen.h"
#include "time.h"

using namespace std;

class Year : public Screen {
private:
  int percent;
  Platform *platform;

public:
  Year(Platform *);
  ~Year();
  void update();
  void refresh();
};
