#pragma once

#include "chars.h"
#include "screen.h"

class Ip : public Screen {
private:
  Platform *platform;
  std::string ip;
  int position;
  int len;

public:
  Ip(Platform *);
  ~Ip();
  void update();
  void refresh();
};
