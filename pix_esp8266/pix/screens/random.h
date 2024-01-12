#pragma once

#include "../screen.h"

class Random : public Screen {
private:
public:
  Random();
  ~Random();
  void update_state();
  void update_pixel_data();
};
